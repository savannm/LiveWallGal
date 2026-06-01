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
        "applyWallpaper", "uploadVideo", "uploadVideoWithMeta",
        "removeUpload", "clearUploads",
        "pickMusic", "scanFolder", "removeScannedVideo", "clearScannedVideos",
        "openCheckout", "openPortal", "restorePurchase", "consoleLog"
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
        case "removeUpload":         handleRemoveUpload(body)
        case "clearUploads":         UploadManager.shared.clearAll()
        case "pickMusic":            openMusicPicker()
        case "scanFolder":           triggerFolderScan()
        case "removeScannedVideo":   handleRemoveScanned(body)
        case "clearScannedVideos":   ScannerManager.shared.clearAll()
        case "openCheckout":         SubscriptionManager.shared.openCheckout()
        case "openPortal":           SubscriptionManager.shared.openCustomerPortal()
        case "restorePurchase":      SubscriptionManager.shared.refreshStatus(); pushSubscriptionState()
        default: break
        }
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
            panel.prompt = "Add to My Uploads"
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
                    self.runJS("switchToUploads(); showToast('\\u{2713} Added \(urls.count) videos to My Uploads')")
                }
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
                let tracks = urls.map { ["name": $0.lastPathComponent, "path": $0.absoluteString] }
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
}
