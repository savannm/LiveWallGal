import Foundation
import AVFoundation
import AppKit

/// A video the user explicitly uploaded via the Upload button.
struct UploadedVideo: Codable {
    let id: String
    let title: String
    let fileName: String
    let fileURLString: String   // file:// absolute URL string
    let category: String
    let resolution: String
    let tags: [String]
    let addedAt: Date
    let thumbnailBase64: String?
    let duration: String?

    var fileURL: URL? { URL(string: fileURLString) }
}

/// Persists uploaded videos across app launches.
/// Storage: UserDefaults (file:// URL strings only — no data copied, just references).
final class UploadManager {

    static let shared = UploadManager()

    private let key = "com.livewallpaper.uploads"
    private(set) var uploads: [UploadedVideo] = []

    /// Called on main thread whenever the list changes.
    var onChange: (([UploadedVideo]) -> Void)?

    private init() {
        load()
        // Remove any entries whose files have been deleted from disk
        prune()
    }

    // MARK: - Public API

    func add(fileURL: URL, title: String, category: String = "Other",
             resolution: String = "Unknown", tags: [String] = []) {
        guard fileURL.isFileURL else { return }
        // Deduplicate by file path
        if uploads.contains(where: { $0.fileURLString == fileURL.absoluteString }) { return }
        
        let entryId = UUID().uuidString
        let entry = UploadedVideo(
            id: entryId,
            title: title.isEmpty ? fileURL.deletingPathExtension().lastPathComponent : title,
            fileName: fileURL.lastPathComponent,
            fileURLString: fileURL.absoluteString,
            category: category,
            resolution: resolution,
            tags: tags.isEmpty ? [category.lowercased()] : tags,
            addedAt: Date(),
            thumbnailBase64: nil,
            duration: "—"
        )
        uploads.insert(entry, at: 0)
        save()
        onChange?(uploads)
        
        // Asynchronously extract actual duration, resolution, and thumbnail frame
        Task {
            let asset = AVAsset(url: fileURL)
            let thumb = await generateThumbnailBase64(asset: asset)
            
            var actualRes = resolution
            var durationStr = "—"
            
            do {
                let tracks = try await asset.loadTracks(withMediaType: .video)
                if let track = tracks.first {
                    let size = try await track.load(.naturalSize)
                    let tf   = try await track.load(.preferredTransform)
                    let transformed = size.applying(tf)
                    let w = Int(abs(transformed.width))
                    let h = Int(abs(transformed.height))
                    if w > 0 && h > 0 { actualRes = "\(w)×\(h)" }
                }
                
                let dur = try await asset.load(.duration)
                let seconds = dur.seconds.isNaN ? 0 : dur.seconds
                if seconds > 0 {
                    let mins = Int(seconds) / 60
                    let secs = Int(seconds) % 60
                    durationStr = String(format: "%d:%02d", mins, secs)
                }
            } catch {}
            
            await MainActor.run {
                if let idx = self.uploads.firstIndex(where: { $0.id == entryId }) {
                    let old = self.uploads[idx]
                    self.uploads[idx] = UploadedVideo(
                        id: old.id,
                        title: old.title,
                        fileName: old.fileName,
                        fileURLString: old.fileURLString,
                        category: old.category,
                        resolution: actualRes,
                        tags: old.tags,
                        addedAt: old.addedAt,
                        thumbnailBase64: thumb,
                        duration: durationStr
                    )
                    self.save()
                    self.onChange?(self.uploads)
                }
            }
        }
    }

    func addMultiple(fileURLs: [URL]) {
        for url in fileURLs {
            guard url.isFileURL,
                  FileManager.default.fileExists(atPath: url.path),
                  !uploads.contains(where: { $0.fileURLString == url.absoluteString })
            else { continue }
            
            self.add(fileURL: url, title: url.deletingPathExtension().lastPathComponent)
        }
    }

    func update(id: String, title: String, category: String, resolution: String, tags: [String]) {
        if let idx = uploads.firstIndex(where: { $0.id == id }) {
            let old = uploads[idx]
            uploads[idx] = UploadedVideo(
                id: old.id,
                title: title.isEmpty ? old.title : title,
                fileName: old.fileName,
                fileURLString: old.fileURLString,
                category: category,
                resolution: resolution,
                tags: tags,
                addedAt: old.addedAt,
                thumbnailBase64: old.thumbnailBase64,
                duration: old.duration
            )
            save()
            onChange?(uploads)
        }
    }

    func remove(id: String) {
        uploads.removeAll { $0.id == id }
        save()
        onChange?(uploads)
    }

    func clearAll() {
        uploads = []
        save()
        onChange?(uploads)
    }

    // MARK: - JS payload

    func jsPayload() -> String {
        let arr: [[String: Any]] = uploads.map { v in [
            "id":       v.id,
            "title":    v.title,
            "fileName": v.fileName,
            "fileURL":  v.fileURLString,
            "cat":      v.category,
            "res":      v.resolution,
            "tags":     v.tags,
            "views":    "0",
            "likes":    "0",
            "dur":      v.duration ?? "—",
            "badge":    "mine",
            "wtype":    "video",
            "colors":   ["#0a0a0f", "#1a1a24", "#2a2a3a", "#7c5cfc"],
            "thumbnail": v.thumbnailBase64 ?? ""
        ]}
        guard let data = try? JSONSerialization.data(withJSONObject: arr),
              let str  = String(data: data, encoding: .utf8) else { return "[]" }
        return str
    }

    private func generateThumbnailBase64(asset: AVAsset) async -> String? {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 320, height: 180)
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        return await withCheckedContinuation { continuation in
            generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { requestedTime, cgImage, actualTime, result, error in
                if result == .succeeded, let cgImage = cgImage {
                    let nsImage = NSImage(cgImage: cgImage, size: NSZeroSize)
                    guard let tiffData = nsImage.tiffRepresentation,
                          let bitmap = NSBitmapImageRep(data: tiffData),
                          let jpegData = bitmap.representation(using: .jpeg, properties: [:]) else {
                        continuation.resume(returning: nil)
                        return
                    }
                    continuation.resume(returning: jpegData.base64EncodedString())
                } else {
                    let timeZero = CMTime(seconds: 0.0, preferredTimescale: 600)
                    generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: timeZero)]) { _, cgImageZero, _, resultZero, _ in
                        if resultZero == .succeeded, let cgImageZero = cgImageZero {
                            let nsImage = NSImage(cgImage: cgImageZero, size: NSZeroSize)
                            guard let tiffData = nsImage.tiffRepresentation,
                                  let bitmap = NSBitmapImageRep(data: tiffData),
                                  let jpegData = bitmap.representation(using: .jpeg, properties: [:]) else {
                                continuation.resume(returning: nil)
                                return
                            }
                            continuation.resume(returning: jpegData.base64EncodedString())
                        } else {
                            continuation.resume(returning: nil)
                        }
                    }
                }
            }
        }
    }

    // MARK: - All granted directories (for WKWebView file access)

    var grantedDirectories: [URL] {
        let dirs = uploads.compactMap { v -> URL? in
            guard let url = v.fileURL else { return nil }
            return url.deletingLastPathComponent()
        }
        return Array(Set(dirs))
    }

    // MARK: - Private

    private func load() {
        guard let data   = UserDefaults.standard.data(forKey: key),
              let loaded = try? JSONDecoder().decode([UploadedVideo].self, from: data)
        else { return }
        uploads = loaded
    }

    private func prune() {
        let before = uploads.count
        uploads = uploads.filter {
            guard let url = $0.fileURL else { return false }
            return FileManager.default.fileExists(atPath: url.path)
        }
        if uploads.count != before { save() }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(uploads) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
