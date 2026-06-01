import SwiftUI
import AppKit

@main
struct LiveWallpaperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No main window — menu bar only
        Settings {
            EmptyView()
        }
    }
}
