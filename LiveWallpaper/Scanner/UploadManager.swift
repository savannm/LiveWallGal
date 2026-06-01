import Foundation

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
        let entry = UploadedVideo(
            id: UUID().uuidString,
            title: title.isEmpty ? fileURL.deletingPathExtension().lastPathComponent : title,
            fileName: fileURL.lastPathComponent,
            fileURLString: fileURL.absoluteString,
            category: category,
            resolution: resolution,
            tags: tags.isEmpty ? [category.lowercased()] : tags,
            addedAt: Date()
        )
        uploads.insert(entry, at: 0)
        save()
        onChange?(uploads)
    }

    func addMultiple(fileURLs: [URL]) {
        var added = 0
        for url in fileURLs {
            guard url.isFileURL,
                  FileManager.default.fileExists(atPath: url.path),
                  !uploads.contains(where: { $0.fileURLString == url.absoluteString })
            else { continue }
            let entry = UploadedVideo(
                id: UUID().uuidString,
                title: url.deletingPathExtension().lastPathComponent,
                fileName: url.lastPathComponent,
                fileURLString: url.absoluteString,
                category: "Other",
                resolution: "Unknown",
                tags: ["video"],
                addedAt: Date()
            )
            uploads.insert(entry, at: 0)
            added += 1
        }
        if added > 0 { save(); onChange?(uploads) }
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
            "dur":      "—",
            "badge":    "mine",
            "wtype":    "video",
            "colors":   ["#0a0a0f", "#1a1a24", "#2a2a3a", "#7c5cfc"],
        ]}
        guard let data = try? JSONSerialization.data(withJSONObject: arr),
              let str  = String(data: data, encoding: .utf8) else { return "[]" }
        return str
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
