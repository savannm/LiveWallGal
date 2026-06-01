import Foundation

struct ScannedVideo: Codable {
    let id: String
    let title: String
    let fileURL: URL
    let fileName: String
    let fileSizeBytes: Int64
    let durationSeconds: Double
    let resolution: String     // e.g. "1920×1080"
    let addedAt: Date

    var fileURLString: String { fileURL.absoluteString }
    var formattedDuration: String {
        let m = Int(durationSeconds) / 60
        let s = Int(durationSeconds) % 60
        return String(format: "%d:%02d", m, s)
    }
    var formattedSize: String {
        let mb = Double(fileSizeBytes) / 1_048_576
        return mb >= 1000
            ? String(format: "%.1f GB", mb / 1024)
            : String(format: "%.1f MB", mb)
    }
}

protocol VideoScannerDelegate: AnyObject {
    func scanner(_ scanner: VideoScanner, didFind videos: [ScannedVideo])
    func scanner(_ scanner: VideoScanner, didUpdateProgress current: Int, total: Int)
    func scannerDidFinish(_ scanner: VideoScanner)
}

final class VideoScanner {

    weak var delegate: VideoScannerDelegate?

    // Video extensions supported by AVFoundation on macOS
    private let videoExtensions: Set<String> = [
        "mp4", "mov", "m4v", "avi", "mkv", "wmv",
        "flv", "webm", "mpg", "mpeg", "ts", "mts"
    ]

    private var scanTask: Task<Void, Never>?

    // MARK: - Public API

    /// Scan a single folder (non-recursive option available)
    func scan(folder: URL, recursive: Bool = true) {
        scanTask?.cancel()
        scanTask = Task.detached(priority: .utility) { [weak self] in
            await self?.performScan(folder: folder, recursive: recursive)
        }
    }

    func cancelScan() {
        scanTask?.cancel()
        scanTask = nil
    }

    // MARK: - Scan implementation

    private func performScan(folder: URL, recursive: Bool) async {
        guard !Task.isCancelled else { return }

        let fm = FileManager.default
        var allURLs: [URL] = []

        // Collect all video file URLs first
        let enumerator = fm.enumerator(
            at: folder,
            includingPropertiesForKeys: [.isRegularFileKey, .fileSizeKey, .contentTypeKey],
            options: recursive ? [] : [.skipsSubdirectoryDescendants]
        )

        while let url = enumerator?.nextObject() as? URL {
            guard !Task.isCancelled else { return }
            guard let res = try? url.resourceValues(forKeys: [.isRegularFileKey]),
                  res.isRegularFile == true else { continue }
            let ext = url.pathExtension.lowercased()
            if videoExtensions.contains(ext) {
                allURLs.append(url)
            }
        }

        let total = allURLs.count
        var found: [ScannedVideo] = []

        for (index, url) in allURLs.enumerated() {
            guard !Task.isCancelled else { return }

            if let video = await makeScannedVideo(url: url) {
                found.append(video)
                // Notify in batches to avoid flooding the main thread
                if found.count % 5 == 0 || found.count == 1 {
                    let batch = found
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        self.delegate?.scanner(self, didFind: batch)
                    }
                }
            }

            let current = index + 1
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.delegate?.scanner(self, didUpdateProgress: current, total: total)
            }
        }

        // Final flush of any remaining
        if !found.isEmpty {
            let final = found
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.delegate?.scanner(self, didFind: final)
            }
        }

        await MainActor.run { [weak self] in
            guard let self else { return }
            self.delegate?.scannerDidFinish(self)
        }
    }

    private func makeScannedVideo(url: URL) async -> ScannedVideo? {
        let fm = FileManager.default
        guard fm.fileExists(atPath: url.path) else { return nil }

        // File size
        let attrs = try? fm.attributesOfItem(atPath: url.path)
        let fileSize = (attrs?[.size] as? Int64) ?? 0

        // Duration + resolution via AVFoundation
        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: false])

        var duration: Double = 0
        var resolution = "Unknown"

        do {
            let dur = try await asset.load(.duration)
            duration = dur.seconds.isNaN ? 0 : dur.seconds

            if let track = try await asset.loadTracks(withMediaType: .video).first {
                let size = try await track.load(.naturalSize)
                let tf   = try await track.load(.preferredTransform)
                let transformed = size.applying(tf)
                let w = Int(abs(transformed.width))
                let h = Int(abs(transformed.height))
                if w > 0 && h > 0 { resolution = "\(w)×\(h)" }
            }
        } catch {
            // Non-critical — just leave defaults
        }

        return ScannedVideo(
            id: UUID().uuidString,
            title: url.deletingPathExtension().lastPathComponent,
            fileURL: url,
            fileName: url.lastPathComponent,
            fileSizeBytes: fileSize,
            durationSeconds: duration,
            resolution: resolution,
            addedAt: Date()
        )
    }
}

// AVFoundation import needed in the same file
import AVFoundation
