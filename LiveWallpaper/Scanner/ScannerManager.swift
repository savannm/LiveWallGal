import Foundation
import AppKit

/// Manages folder scanning state and persists scanned video library to UserDefaults.
final class ScannerManager: VideoScannerDelegate {

    static let shared = ScannerManager()

    private let scanner = VideoScanner()
    private let storageKey = "com.livewallpaper.scannedVideos"

    /// All scanned videos, deduplicated by file path
    private(set) var scannedVideos: [ScannedVideo] = []

    /// Called on main thread whenever videos are added or scan completes
    var onUpdate: (([ScannedVideo]) -> Void)?
    var onProgress: ((Int, Int) -> Void)?
    var onFinished: (() -> Void)?

    private(set) var isScanning = false
    private var scannedPaths: Set<String> = []     // fast dedup

    private init() {
        scanner.delegate = self
        loadPersisted()
    }

    // MARK: - Public

    func scanFolder(_ url: URL) {
        isScanning = true
        scanner.scan(folder: url, recursive: true)
    }

    func cancelScan() {
        scanner.cancelScan()
        isScanning = false
    }

    func removeVideo(id: String) {
        scannedVideos.removeAll { $0.id == id }
        scannedPaths = Set(scannedVideos.map { $0.fileURL.path })
        persist()
        onUpdate?(scannedVideos)
    }

    func clearAll() {
        scannedVideos = []
        scannedPaths  = []
        persist()
        onUpdate?(scannedVideos)
    }

    // MARK: - VideoScannerDelegate

    func scanner(_ scanner: VideoScanner, didFind videos: [ScannedVideo]) {
        // Deduplicate by file path
        let newVideos = videos.filter { !scannedPaths.contains($0.fileURL.path) }
        newVideos.forEach { scannedPaths.insert($0.fileURL.path) }
        scannedVideos.append(contentsOf: newVideos)
        persist()
        onUpdate?(scannedVideos)
    }

    func scanner(_ scanner: VideoScanner, didUpdateProgress current: Int, total: Int) {
        onProgress?(current, total)
    }

    func scannerDidFinish(_ scanner: VideoScanner) {
        isScanning = false
        onFinished?()
    }

    // MARK: - Persistence

    private func persist() {
        if let data = try? JSONEncoder().encode(scannedVideos) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadPersisted() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let videos = try? JSONDecoder().decode([ScannedVideo].self, from: data) else { return }
        // Filter out files that no longer exist on disk
        scannedVideos = videos.filter { FileManager.default.fileExists(atPath: $0.fileURL.path) }
        scannedPaths  = Set(scannedVideos.map { $0.fileURL.path })
    }

    // MARK: - JS payload helper

    /// Serialise scanned videos to a JSON string safe to inject into JavaScript
    func jsPayload() -> String {
        let arr = scannedVideos.map { v -> [String: Any] in [
            "id":       v.id,
            "title":    v.title,
            "fileName": v.fileName,
            "fileURL":  v.fileURLString,
            "size":     v.formattedSize,
            "duration": v.formattedDuration,
            "res":      v.resolution,
            "thumbnail": v.thumbnailBase64 ?? ""
        ]}
        guard let data = try? JSONSerialization.data(withJSONObject: arr),
              let str  = String(data: data, encoding: .utf8) else { return "[]" }
        return str
    }
}
