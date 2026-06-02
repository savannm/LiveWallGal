import WebKit
import UniformTypeIdentifiers

class AppDelegate: NSObject, NSApplicationDelegate, BrowserWindowDelegate {
    var statusItem: NSStatusItem?
    var wallpaperWindows: [WallpaperWindow] = []
    var browserWindow: BrowserWindow?

    // ── Default mode: video if a upload exists, otherwise particles ──
    var currentMode: WallpaperMode = .particles {
        didSet {
            UserDefaults.standard.set(currentMode.rawValue, forKey: "lastMode")
            refreshWallpapers()
        }
    }
    var videoURL: URL? = nil {
        didSet {
            if let url = videoURL {
                UserDefaults.standard.set(url.absoluteString, forKey: "lastVideoURL")
            }
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        restoreLastMode()
        setupMenuBar()
        createWallpaperWindows()
        SubscriptionManager.shared.refreshStatus()
        
        // Open the browser GUI automatically on launch/compile
        openBrowser()
    }

    /// Restore last-used mode and video URL, defaulting to the first upload if available
    private func restoreLastMode() {
        // If user has uploads, default to video mode with their first upload
        if let firstUpload = UploadManager.shared.uploads.first,
           let url = firstUpload.fileURL {
            videoURL = url
            let saved = UserDefaults.standard.string(forKey: "lastMode") ?? "video"
            currentMode = WallpaperMode(rawValue: saved) ?? .video
        } else if let savedMode = UserDefaults.standard.string(forKey: "lastMode"),
                  let mode = WallpaperMode(rawValue: savedMode) {
            currentMode = mode
            if let urlStr = UserDefaults.standard.string(forKey: "lastVideoURL"),
               let url = URL(string: urlStr), url.isFileURL,
               FileManager.default.fileExists(atPath: url.path) {
                videoURL = url
            }
        }
        // else stays .particles (the existing default)
    }

    // MARK: - URL scheme (Stripe callback)

    func application(_ application: NSApplication, open urls: [URL]) {
        urls.forEach { SubscriptionManager.shared.handleCallbackURL($0) }
    }

    // MARK: - Menu Bar

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sparkles.tv",
                                   accessibilityDescription: "Live Wallpaper")
        }

        let menu = NSMenu()

        let browseItem = NSMenuItem(title: "Browse Wallpapers…",
                                    action: #selector(openBrowser), keyEquivalent: "b")
        browseItem.target = self
        menu.addItem(browseItem)

        menu.addItem(NSMenuItem.separator())

        // Mode submenu
        let modeMenu = NSMenu()
        for mode in WallpaperMode.allCases {
            let item = NSMenuItem(title: mode.displayName,
                                  action: #selector(selectMode(_:)), keyEquivalent: "")
            item.representedObject = mode
            item.target = self
            if mode == currentMode { item.state = .on }
            modeMenu.addItem(item)
        }
        let modeItem = NSMenuItem(title: "Wallpaper Mode", action: nil, keyEquivalent: "")
        menu.addItem(modeItem)
        menu.setSubmenu(modeMenu, for: modeItem)

        menu.addItem(NSMenuItem.separator())

        // Settings submenu
        let settingsMenu = NSMenu()

        let cacheItem = NSMenuItem(title: "Clear App Cache",
                                   action: #selector(clearCache), keyEquivalent: "")
        cacheItem.target = self
        settingsMenu.addItem(cacheItem)

        let clearUploadsItem = NSMenuItem(title: "Clear Video Collection Library",
                                          action: #selector(clearUploadsLibrary), keyEquivalent: "")
        clearUploadsItem.target = self
        settingsMenu.addItem(clearUploadsItem)

        let clearScannedItem = NSMenuItem(title: "Clear Scanned Videos",
                                          action: #selector(clearScannedVideos), keyEquivalent: "")
        clearScannedItem.target = self
        settingsMenu.addItem(clearScannedItem)

        let settingsItem = NSMenuItem(title: "Settings", action: nil, keyEquivalent: "")
        menu.addItem(settingsItem)
        menu.setSubmenu(settingsMenu, for: settingsItem)

        menu.addItem(NSMenuItem.separator())

        // Subscription
        let subItem = NSMenuItem(title: subscriptionMenuTitle(),
                                 action: #selector(openSubscription), keyEquivalent: "")
        subItem.tag = 99
        subItem.target = self
        menu.addItem(subItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit Live Wallpaper",
                                  action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)

        statusItem?.menu = menu

        SubscriptionManager.shared.onStatusChange = { [weak self] _ in
            self?.updateSubscriptionMenuItem()
        }
    }

    // MARK: - Settings actions

    @objc func clearCache() {
        let alert = NSAlert()
        alert.messageText = "Clear App Cache?"
        alert.informativeText = "This clears the WKWebView disk cache and temporary files. Your uploads library is not affected."
        alert.addButton(withTitle: "Clear Cache")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        guard alert.runModal() == .alertFirstButtonReturn else { return }

        // Clear WKWebView cache
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        WKWebsiteDataStore.default().removeData(ofTypes: types,
                                                 modifiedSince: .distantPast) { }

        // Clear temp HTML file
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("backdrop_browser.html")
        try? FileManager.default.removeItem(at: tmp)

        showNotification(title: "Cache Cleared", body: "App cache has been cleared successfully.")
    }

    @objc func clearUploadsLibrary() {
        let alert = NSAlert()
        alert.messageText = "Clear Video Collection?"
        alert.informativeText = "Removes all videos from your video collection. Original files on disk are NOT deleted."
        alert.addButton(withTitle: "Clear Library")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        guard alert.runModal() == .alertFirstButtonReturn else { return }
        UploadManager.shared.clearAll()
        // If currently in video mode with an upload, switch to particles
        if currentMode == .video {
            currentMode = .particles
            updateModeMenuChecks()
        }
        showNotification(title: "Library Cleared", body: "Your video collection has been cleared.")
    }

    @objc func clearScannedVideos() {
        let alert = NSAlert()
        alert.messageText = "Clear Scanned Videos?"
        alert.informativeText = "Removes all scanned video entries. Original files on disk are NOT deleted."
        alert.addButton(withTitle: "Clear")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        guard alert.runModal() == .alertFirstButtonReturn else { return }
        ScannerManager.shared.clearAll()
        showNotification(title: "Cleared", body: "Scanned video list has been cleared.")
    }

    private func showNotification(title: String, body: String) {
        // Simple NSAlert feedback (no notification permission needed)
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = body
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .informational
        alert.runModal()
    }

    // MARK: - Subscription

    private func subscriptionMenuTitle() -> String {
        let sub = SubscriptionManager.shared
        if sub.isSubscribed { return "✓ Subscribed — Manage…" }
        if sub.isInTrial    { return "⏳ Trial — \(sub.trialDaysRemaining)d left — Upgrade" }
        return "🔒 Subscribe — \(SubscriptionManager.priceDisplay)"
    }

    private func updateSubscriptionMenuItem() {
        statusItem?.menu?.items.first(where: { $0.tag == 99 })?.title = subscriptionMenuTitle()
    }

    @objc func openSubscription() {
        if SubscriptionManager.shared.isSubscribed {
            SubscriptionManager.shared.openCustomerPortal()
        } else {
            openBrowser()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.browserWindow?.runJS("showPaywall()")
            }
        }
    }

    // MARK: - Browser

    @objc func openBrowser() {
        if browserWindow == nil {
            browserWindow = BrowserWindow()
            browserWindow?.browserDelegate = self
        }
        browserWindow?.showAndFocus()
    }

    func browserWindow(_ window: BrowserWindow, didSelectMode mode: WallpaperMode) {
        currentMode = mode
        updateModeMenuChecks()
    }

    func browserWindow(_ window: BrowserWindow, didSelectVideoURL url: URL) {
        videoURL = url
        currentMode = .video
        updateModeMenuChecks()
    }

    func browserWindowWillClose(_ window: BrowserWindow) {
        browserWindow = nil
    }

    private func updateModeMenuChecks() {
        guard let sub = statusItem?.menu?.items.first(where: { $0.title == "Wallpaper Mode" })?.submenu
        else { return }
        sub.items.forEach { $0.state = ($0.representedObject as? WallpaperMode) == currentMode ? .on : .off }
    }

    // MARK: - Mode & Video

    @objc func selectMode(_ sender: NSMenuItem) {
        guard let mode = sender.representedObject as? WallpaperMode else { return }
        sender.menu?.items.forEach { $0.state = .off }
        sender.state = .on
        currentMode = mode
    }

    @objc func loadVideoFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.movie, .mpeg4Movie, .quickTimeMovie]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            videoURL = panel.url
            currentMode = .video
            updateModeMenuChecks()
        }
    }

    // MARK: - Wallpaper windows

    func createWallpaperWindows() {
        wallpaperWindows.forEach { $0.orderOut(nil); $0.contentView = nil }
        wallpaperWindows = []
        for screen in NSScreen.screens {
            wallpaperWindows.append(WallpaperWindow(screen: screen,
                                                    mode: currentMode,
                                                    videoURL: videoURL))
        }
    }

    func refreshWallpapers() {
        wallpaperWindows.forEach { $0.orderOut(nil); $0.contentView = nil }
        wallpaperWindows = []
        createWallpaperWindows()
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        refreshWallpapers()
    }
}
