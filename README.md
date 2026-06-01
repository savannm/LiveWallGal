# Live Wallpaper for macOS

A menu-bar macOS app that renders live animated wallpapers behind your desktop icons.
Supports 4 modes: Looping Video, Metal Shader (Aurora), HTML5 Canvas (Neon Ribbons), and Particle Effects (Fireworks).

---

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15+

---

## How to Build & Run

1. Open `LiveWallpaper.xcodeproj` in Xcode
2. Select your Mac as the run destination
3. Press **⌘R** to build and run
4. A ✦ sparkles icon appears in your menu bar — no Dock icon (by design)

---

## Switching Modes

Click the menu bar icon → **Wallpaper Mode** → pick one:

| Mode | Description |
|------|-------------|
| 🎬 Looping Video | Plays an MP4/MOV file on loop |
| 🌊 Animated Shader | Metal GPU aurora shader |
| 🌐 HTML5 Canvas | Neon ribbon WebKit animation |
| ✨ Particle Effects | SpriteKit fireworks + dust |

For **Looping Video**, click **Load Video File…** to pick an `.mp4` or `.mov`.

---

## Project Structure

```
LiveWallpaper/
├── LiveWallpaperApp.swift          # @main entry, SwiftUI App
├── WallpaperWindow.swift           # Borderless NSWindow at desktop level
├── WallpaperMode.swift             # Mode enum
├── Info.plist                      # LSUIElement = YES (no Dock icon)
├── MenuBar/
│   └── AppDelegate.swift           # Status bar item, mode switching
└── Wallpapers/
    ├── VideoWallpaperView.swift     # AVPlayer looping video
    ├── ShaderWallpaperView.swift    # Metal MTKView aurora shader
    ├── HTMLWallpaperView.swift      # WKWebView HTML5 canvas
    └── ParticleWallpaperView.swift  # SpriteKit particles & fireworks
```

---

## How It Works

The key trick is `NSWindow.Level`:

```swift
level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) - 1)
```

This places the window **above** the solid desktop colour but **below** Finder icons and all app windows.

Combined with:
```swift
collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
```
…it persists across all Spaces and Mission Control without appearing in ⌘Tab.

---

## Performance Tips

- The app throttles nothing by default. For battery savings, add `NSProcessInfo` power state observation in `AppDelegate` to pause rendering on battery.
- The Metal shader targets 60 fps; lower `preferredFramesPerSecond` in `ShaderWallpaperView` if needed.
- For video mode, `AVPlayer` hardware-decodes on Apple Silicon — very efficient.

---

## Customising the Shader

Edit the Metal shader source string in `ShaderWallpaperView.swift`. The fragment shader receives a `time` float uniform (seconds since launch). Any GLSL-style Metal shader works — swap in your own.

---

## Customising the HTML Wallpaper

Edit the `htmlContent` string in `HTMLWallpaperView.swift`. It's plain HTML/JS/Canvas — you can drop in any Three.js, p5.js, or custom canvas animation by adding a `<script src>` tag pointing to a CDN.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Window appears on top of everything | Check `level` assignment in `WallpaperWindow.swift` |
| Video doesn't loop | Ensure `.AVPlayerItemDidPlayToEndTime` notification fires; check URL is valid |
| Shader is black | Metal requires a real GPU — won't work in some VMs |
| App appears in Dock | Confirm `LSUIElement = YES` in `Info.plist` |
