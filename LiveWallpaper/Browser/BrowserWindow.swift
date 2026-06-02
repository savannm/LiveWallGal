import AppKit
import WebKit

protocol BrowserWindowDelegate: AnyObject {
    func browserWindow(_ window: BrowserWindow, didSelectVideoURL url: URL)
    func browserWindow(_ window: BrowserWindow, didSelectMode mode: WallpaperMode)
    func browserWindowWillClose(_ window: BrowserWindow)
}

class BrowserWindow: NSWindow, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {

    weak var browserDelegate: BrowserWindowDelegate?
    private var webView: WKWebView!
    private var htmlLoaded = false
    private var pendingJS: [String] = []

    private let allowedMessages: Set<String> = [
        "applyWallpaper", "uploadVideo", "uploadVideoWithMeta", "updateUploadMeta",
        "removeUpload", "clearUploads",
        "pickMusic", "scanFolder", "removeScannedVideo", "clearScannedVideos",
        "openCheckout", "openPortal", "restorePurchase", "consoleLog", "clearCache",
        "openURL", "setDownloadDir", "downloadVideo", "searchOnline", "startWindowDrag",
        "pickBgImage"
    ]

    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 1140, height: 740),
            styleMask: [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        isReleasedWhenClosed = true
        title = "Live Wallpaper"
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        backgroundColor = NSColor(red: 0.039, green: 0.039, blue: 0.059, alpha: 1)
        minSize = NSSize(width: 820, height: 560)
        setupWebView()
        setupCallbacks()
        center()
    }

    // MARK: - WebView

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.setURLSchemeHandler(LocalFileSchemeHandler(), forURLScheme: "local-file")
        allowedMessages.forEach { config.userContentController.add(self, name: $0) }

        // Frame must match the window content area — NOT .zero
        let frame = NSRect(x: 0, y: 0, width: 1140, height: 740)
        webView = WKWebView(frame: frame, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.autoresizingMask = [.width, .height]

        // Do NOT call setValue(false, drawsBackground) — it can cause black
        // Instead set a matching background color
        webView.underPageBackgroundColor = NSColor(red: 0.039, green: 0.039, blue: 0.059, alpha: 1)

        contentView = webView
        loadHTML()
    }

    // MARK: - HTML loading
    // loadHTMLString is the most reliable approach — no sandbox path issues,
    // no file:// permission problems. Works in both sandboxed and non-sandboxed.
    // Media (video/audio) is handled separately via evaluateJavaScript src injection.

    func loadHTML() {
        htmlLoaded = false
        let baseURL = Bundle.main.resourceURL ?? URL(fileURLWithPath: NSTemporaryDirectory())
        webView.loadHTMLString(browserHTML, baseURL: baseURL)
    }

    // MARK: - Navigation

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("WEBVIEW: didFinish navigation called successfully.")
        htmlLoaded = true
        pushUploads()
        pushScannedVideos()
        pushSubscriptionState()
        pushDownloadDir()
        let q = pendingJS; pendingJS = []
        q.forEach { webView.evaluateJavaScript($0, completionHandler: nil) }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog("WEBVIEW ERROR: didFailProvisionalNavigation: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("WEBVIEW ERROR: didFail navigation: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = action.request.url, let scheme = url.scheme else { decisionHandler(.allow); return }
        NSLog("WEBVIEW: decidePolicyFor url=\(url.absoluteString) scheme=\(scheme)")
        // Block all external navigation; allow about:blank and file
        let allowed = ["about", "file", "blob"]
        decisionHandler(allowed.contains(scheme) ? .allow : .cancel)
    }

    // MARK: - JS → Swift

    func userContentController(_ userContentController: WKUserContentController,
                                didReceive message: WKScriptMessage) {
        guard allowedMessages.contains(message.name) else { return }
        let body = message.body as? [String: Any] ?? [:]
        switch message.name {
        case "consoleLog":
            if let msg = body["message"] as? String {
                NSLog("JS CONSOLE: \(msg)")
            }
        case "applyWallpaper":       handleApply(body)
        case "uploadVideo":          openVideoPicker()
        case "uploadVideoWithMeta":  handleUploadWithMeta(body)
        case "updateUploadMeta":     handleUpdateUploadMeta(body)
        case "removeUpload":         handleRemoveUpload(body)
        case "clearUploads":         UploadManager.shared.clearAll()
        case "pickMusic":            openMusicPicker()
        case "scanFolder":           triggerFolderScan()
        case "removeScannedVideo":   handleRemoveScanned(body)
        case "clearScannedVideos":   ScannerManager.shared.clearAll()
        case "openCheckout":         SubscriptionManager.shared.openCheckout()
        case "openPortal":           SubscriptionManager.shared.openCustomerPortal()
        case "restorePurchase":      SubscriptionManager.shared.refreshStatus(); pushSubscriptionState()
        case "clearCache":           handleClearCache()
        case "openURL":              handleOpenURL(body)
        case "setDownloadDir":       handleSetDownloadDir()
        case "downloadVideo":        handleDownloadVideo(body)
        case "searchOnline":         handleSearchOnline(body)
        case "pickBgImage":          openBgImagePicker()
        case "startWindowDrag":
            DispatchQueue.main.async { [weak self] in
                if let event = NSApp.currentEvent {
                    self?.performDrag(with: event)
                }
            }
        default: break
        }
    }

    // MARK: - Clear cache (from browser Settings panel)

    private func handleClearCache() {
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: .distantPast) { }
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("backdrop_browser.html")
        try? FileManager.default.removeItem(at: tmp)
        runJS("showToast('\\u{2713} App cache cleared')")
    }

    private func handleOpenURL(_ body: [String: Any]) {
        guard let urlStr = body["url"] as? String,
              let url = URL(string: urlStr),
              (url.scheme == "https" || url.scheme == "http")
        else { return }
        DispatchQueue.main.async {
            NSWorkspace.shared.open(url)
        }
    }

    // MARK: - Download dir (Settings)

    private let downloadDirKey = "WallpaperDownloadDir"

    private func downloadDir() -> URL {
        if let saved = UserDefaults.standard.string(forKey: downloadDirKey),
           !saved.isEmpty {
            return URL(fileURLWithPath: saved)
        }
        return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
    }

    private func pushDownloadDir() {
        let path = downloadDir().path
        let safe = path.replacingOccurrences(of: "'", with: "\\'")
        runJS("onDownloadDirChanged('\(safe)')")
    }

    private func handleSetDownloadDir() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let panel = NSOpenPanel()
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false
            panel.prompt = "Select Download Folder"
            panel.directoryURL = self.downloadDir()
            panel.beginSheetModal(for: self) { [weak self] response in
                guard let self, response == .OK, let url = panel.url else { return }
                UserDefaults.standard.set(url.path, forKey: self.downloadDirKey)
                self.pushDownloadDir()
            }
        }
    }

    // MARK: - Download video (Browse Online)

    private func handleDownloadVideo(_ body: [String: Any]) {
        guard let urlStr = body["url"] as? String,
              let url = URL(string: urlStr),
              url.scheme == "https"
        else { return }
        let title = (body["title"] as? String ?? "wallpaper")
            .replacingOccurrences(of: "/", with: "-")
        let destDir = downloadDir()
        try? FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)
        let filename = title + ".mp4"
        let destURL  = destDir.appendingPathComponent(filename)
        let safeTitle = title.replacingOccurrences(of: "'", with: "\\'")

        let task = URLSession.shared.downloadTask(with: url) { [weak self] tmpURL, _, error in
            guard let self else { return }
            if let error {
                NSLog("Download failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let errSafe = error.localizedDescription.replacingOccurrences(of: "'", with: "\\'")
                    self.runJS("onDownloadFailed('\(safeTitle)','\(errSafe)')")
                }
                return
            }
            guard let tmpURL else { return }
            try? FileManager.default.removeItem(at: destURL)
            do {
                try FileManager.default.moveItem(at: tmpURL, to: destURL)
                DispatchQueue.main.async {
                    UploadManager.shared.add(fileURL: destURL, title: title)
                    self.runJS("onDownloadComplete('\(safeTitle)')")
                    NSWorkspace.shared.activateFileViewerSelecting([destURL])
                }
            } catch {
                DispatchQueue.main.async {
                    let errSafe = error.localizedDescription.replacingOccurrences(of: "'", with: "\\'")
                    self.runJS("onDownloadFailed('\(safeTitle)','\(errSafe)')")
                }
            }
        }
        task.resume()
    }

    // MARK: - Apply wallpaper

    private func handleApply(_ body: [String: Any]) {
        let type  = body["type"]      as? String ?? ""
        let vpath = body["videoPath"] as? String ?? ""
        DispatchQueue.main.async {
            if type == "video", !vpath.isEmpty,
               let url = URL(string: vpath), url.isFileURL,
               FileManager.default.fileExists(atPath: url.path) {
                self.browserDelegate?.browserWindow(self, didSelectVideoURL: url)
            } else {
                let mode: WallpaperMode
                switch type {
                case "shader":    mode = .shader
                case "html":      mode = .html
                case "particles": mode = .particles
                default: return
                }
                self.browserDelegate?.browserWindow(self, didSelectMode: mode)
            }
        }
    }

    // MARK: - Upload video picker
    // NOTE: Because we use loadHTMLString (not loadFileURL), WKWebView cannot
    // load file:// video src directly. Instead we use AVPlayer in VideoWallpaperView
    // for playback. The browser preview uses a canvas gradient thumb only.
    // Full video preview is handled natively when user clicks Apply.

    private func openVideoPicker() {
        DispatchQueue.main.async {
                let panel = NSOpenPanel()
            panel.allowedContentTypes = [.movie, .mpeg4Movie, .quickTimeMovie]
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = false
            panel.prompt = "Add to Video Collection"
            panel.beginSheetModal(for: self) { [weak self] r in
                guard let self, r == .OK else { return }
                let urls = panel.urls.filter {
                    $0.isFileURL && FileManager.default.fileExists(atPath: $0.path)
                }
                guard !urls.isEmpty else { return }

                if urls.count == 1 {
                    let url = urls[0]
                    let name = self.jsEscape(url.lastPathComponent)
                    let path = self.jsEscape(url.absoluteString)
                    self.runJS("onVideoPickerReady([{name:'\(name)',path:'\(path)'}])")
                } else {
                    UploadManager.shared.addMultiple(fileURLs: urls)
                    self.runJS("switchToUploads(); showToast('✓ Added \(urls.count) videos to Video Collection')")
                }
            }
        }
    }

    private func openBgImagePicker() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let panel = NSOpenPanel()
            panel.allowedContentTypes = [.image, .png, .jpeg, .webP]
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.prompt = "Select Background Image"
            panel.beginSheetModal(for: self) { [weak self] response in
                guard let self = self, response == .OK, let url = panel.url else { return }
                let path = url.path
                let name = url.lastPathComponent
                let escapedPath = self.jsEscape(path)
                let escapedName = self.jsEscape(name)
                let localFileURL = "local-file://\(escapedPath)"
                self.runJS("onBgImagePicked('\(localFileURL)', '\(escapedName)')")
            }
        }
    }

    private func handleUploadWithMeta(_ body: [String: Any]) {
        guard let path = body["path"] as? String,
              let url  = URL(string: path), url.isFileURL,
              FileManager.default.fileExists(atPath: url.path)
        else { return }
        let title      = body["title"]      as? String ?? ""
        let category   = body["category"]   as? String ?? "Other"
        let resolution = body["resolution"] as? String ?? "Unknown"
        let tagsRaw    = body["tags"]       as? String ?? ""
        let tags       = tagsRaw.split(separator: ",")
                                .map { $0.trimmingCharacters(in: .whitespaces) }
                                .filter { !$0.isEmpty }
        UploadManager.shared.add(fileURL: url, title: title, category: category,
                                 resolution: resolution, tags: tags)
        runJS("switchToUploads()")
    }

    private func handleRemoveUpload(_ body: [String: Any]) {
        guard let id = body["id"] as? String else { return }
        UploadManager.shared.remove(id: id)
    }

    private func handleUpdateUploadMeta(_ body: [String: Any]) {
        guard let id = body["id"] as? String else { return }
        let title      = body["title"]      as? String ?? ""
        let category   = body["category"]   as? String ?? "Other"
        let resolution = body["resolution"] as? String ?? "Unknown"
        let tagsRaw    = body["tags"]       as? String ?? ""
        let tags       = tagsRaw.split(separator: ",")
                                .map { $0.trimmingCharacters(in: .whitespaces) }
                                .filter { !$0.isEmpty }
        UploadManager.shared.update(id: id, title: title, category: category, resolution: resolution, tags: tags)
    }

    // MARK: - Music picker

    private func openMusicPicker() {
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.allowedContentTypes = [.audio, .mp3, .mpeg4Audio]
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = false
            panel.beginSheetModal(for: self) { [weak self] r in
                guard let self, r == .OK else { return }
                let urls = panel.urls.filter {
                    $0.isFileURL && FileManager.default.fileExists(atPath: $0.path)
                }
                guard !urls.isEmpty else { return }
                let tracks = urls.map { ["name": $0.lastPathComponent, "path": $0.absoluteString.replacingOccurrences(of: "file://", with: "local-file://")] }
                if let data = try? JSONSerialization.data(withJSONObject: tracks),
                   let str  = String(data: data, encoding: .utf8) {
                    self.runJS("onMusicPicked(\(str))")
                }
            }
        }
    }

    // MARK: - Folder scan

    private func triggerFolderScan() {
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false
            panel.prompt = "Scan Folder"
            panel.message = "Choose a folder to scan for video files"
            panel.beginSheetModal(for: self) { [weak self] r in
                guard let self, r == .OK, let url = panel.url else { return }
                self.runJS("onScanStarted()")
                ScannerManager.shared.scanFolder(url)
            }
        }
    }

    private func handleRemoveScanned(_ body: [String: Any]) {
        guard let id = body["id"] as? String else { return }
        ScannerManager.shared.removeVideo(id: id)
    }

    // MARK: - Push state to JS

    private func pushUploads() {
        runJS("onUploadsChanged(\(UploadManager.shared.jsPayload()))")
    }

    private func pushScannedVideos() {
        runJS("onScannedVideosUpdated(\(ScannerManager.shared.jsPayload()))")
    }

    private func pushSubscriptionState() {
        let sub = SubscriptionManager.shared
        runJS("onSubscriptionState({subscribed:\(sub.isSubscribed),trial:\(sub.isInTrial),trialDays:\(sub.trialDaysRemaining),price:'\(SubscriptionManager.priceDisplay)'})")
    }

    // MARK: - Callbacks

    private func setupCallbacks() {
        UploadManager.shared.onChange = { [weak self] _ in
            self?.pushUploads()
        }
        ScannerManager.shared.onUpdate = { [weak self] _ in
            self?.pushScannedVideos()
        }
        ScannerManager.shared.onProgress = { [weak self] cur, tot in
            self?.runJS("onScanProgress(\(cur),\(tot))")
        }
        ScannerManager.shared.onFinished = { [weak self] in
            self?.runJS("onScanFinished()")
            self?.pushScannedVideos()
        }
        SubscriptionManager.shared.onStatusChange = { [weak self] _ in
            self?.pushSubscriptionState()
        }
    }

    // MARK: - Helpers

    func runJS(_ js: String) {
        DispatchQueue.main.async {
            let silencedJS = js.hasSuffix("; 0;") ? js : js + "; 0;"
            if self.htmlLoaded {
                self.webView.evaluateJavaScript(silencedJS) { result, error in
                    if let error = error {
                        NSLog("JS EVALUATION ERROR: \(error.localizedDescription) for JS: \(silencedJS)")
                    }
                }
            } else {
                self.pendingJS.append(silencedJS)
            }
        }
    }

    private func jsEscape(_ s: String) -> String {
        s.replacingOccurrences(of: "\\", with: "\\\\")
         .replacingOccurrences(of: "'",  with: "\\'")
         .replacingOccurrences(of: "\n", with: "\\n")
    }

    // MARK: - WKUIDelegate

    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = "Live Wallpaper"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .informational
        alert.beginSheetModal(for: self) { _ in
            completionHandler()
        }
    }

    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = "Live Wallpaper"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self) { response in
            completionHandler(response == .alertFirstButtonReturn)
        }
    }

    // MARK: - Show / Hide

    func showAndFocus() {
        NSApp.setActivationPolicy(.regular)
        makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    override func close() {
        // Break script message handler retain cycle so this window can be safely deallocated
        allowedMessages.forEach { webView.configuration.userContentController.removeScriptMessageHandler(forName: $0) }
        
        browserDelegate?.browserWindowWillClose(self)
        super.close()
        NSApp.setActivationPolicy(.accessory)
    }

    // MARK: - Live Search Online

    private func handleSearchOnline(_ body: [String: Any]) {
        guard let query = body["query"] as? String else { return }
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.runJS("onOnlineSearchResults([])")
            return
        }
        
        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://wallsflow.com/?s=\(encoded)")
        else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                NSLog("Online search error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.runJS("onOnlineSearchFailed('\(self.jsEscape(error.localizedDescription))')")
                }
                return
            }
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    self.runJS("onOnlineSearchFailed('Failed to load data')")
                }
                return
            }
            
            let results = self.parseWallsflowHTML(html)
            DispatchQueue.main.async {
                if let jsonData = try? JSONSerialization.data(withJSONObject: results),
                   let jsonStr = String(data: jsonData, encoding: .utf8) {
                    self.runJS("onOnlineSearchResults(\(jsonStr))")
                } else {
                    self.runJS("onOnlineSearchResults([])")
                }
            }
        }
        task.resume()
    }

    private func parseWallsflowHTML(_ html: String) -> [[String: Any]] {
        var results: [[String: Any]] = []
        let cards = html.components(separatedBy: "<div class=\"relative overflow-hidden h-[260px]")
        guard cards.count > 1 else { return [] }
        
        for card in cards[1...] {
            // Find image src
            var thumb = ""
            if let range = card.range(of: "<img\\s+src=\"([^\"]+)\"", options: .regularExpression) {
                let imgSub = String(card[range])
                if let srcRange = imgSub.range(of: "src=\"([^\"]+)\"", options: .regularExpression) {
                    var src = String(imgSub[srcRange])
                    src = src.replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    thumb = src
                }
            }
            
            // Find video data-src
            var video = ""
            if let range = card.range(of: "<source\\s+data-src=\"([^\"]+)\"", options: .regularExpression) {
                let vidSub = String(card[range])
                if let srcRange = vidSub.range(of: "data-src=\"([^\"]+)\"", options: .regularExpression) {
                    var src = String(vidSub[srcRange])
                    src = src.replacingOccurrences(of: "data-src=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    video = src
                }
            }
            
            // Find page link and title (aria-label)
            var page = ""
            var title = ""
            if let range = card.range(of: "<a\\s+href=\"([^\"]+)\"\\s+class=\"absolute[^\"]+\"\\s+aria-label=\"([^\"]+)\"", options: .regularExpression) {
                let aSub = String(card[range])
                // Extract href
                if let hrefRange = aSub.range(of: "href=\"([^\"]+)\"", options: .regularExpression) {
                    var h = String(aSub[hrefRange])
                    h = h.replacingOccurrences(of: "href=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    page = h
                }
                // Extract aria-label
                if let labelRange = aSub.range(of: "aria-label=\"([^\"]+)\"", options: .regularExpression) {
                    var l = String(aSub[labelRange])
                    l = l.replacingOccurrences(of: "aria-label=\"", with: "").replacingOccurrences(of: "\"", with: "")
                    l = l.replacingOccurrences(of: "&amp;", with: "&")
                         .replacingOccurrences(of: "&#039;", with: "'")
                         .replacingOccurrences(of: "&quot;", with: "\"")
                    title = l
                }
            }
            
            if !thumb.isEmpty && !video.isEmpty && !title.isEmpty {
                results.append([
                    "title": title,
                    "cat": "Games",
                    "page": page,
                    "thumb": thumb,
                    "video": video
                ])
            }
        }
        return results
    }
}

class LocalFileSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url,
              let path = url.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let decodedPath = path.removingPercentEncoding else {
            urlSchemeTask.didFailWithError(NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError, userInfo: nil))
            return
        }
        
        let fileURL = URL(fileURLWithPath: decodedPath)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let mimeType = mimeTypeForPath(fileURL.path)
            let response = URLResponse(url: url, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: nil)
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } catch {
            urlSchemeTask.didFailWithError(error)
        }
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}
    
    private func mimeTypeForPath(_ path: String) -> String {
        let ext = (path as NSString).pathExtension.lowercased()
        switch ext {
        case "mp3": return "audio/mpeg"
        case "m4a": return "audio/mp4"
        case "wav": return "audio/wav"
        case "mp4": return "video/mp4"
        case "mov": return "video/quicktime"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "webp": return "image/webp"
        default: return "application/octet-stream"
        }
    }
}
