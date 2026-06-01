import AppKit

class WallpaperWindow: NSWindow {

    init(screen: NSScreen, mode: WallpaperMode, videoURL: URL?) {
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        // CRITICAL: prevent ARC from deallocating the window after display
        isReleasedWhenClosed = false

        // Sit behind Finder icons, above solid desktop colour
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) - 1)

        // Persist across Spaces and Mission Control
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]

        isOpaque = true
        hasShadow = false
        ignoresMouseEvents = true
        backgroundColor = .black

        // Fill screen exactly
        setFrame(screen.frame, display: false)

        // Attach the right content view
        switch mode {
        case .video:
            contentView = VideoWallpaperView(videoURL: videoURL)
        case .shader:
            contentView = ShaderWallpaperView()
        case .html:
            contentView = HTMLWallpaperView()
        case .particles:
            contentView = ParticleWallpaperView()
        }

        orderFrontRegardless()
    }
}
