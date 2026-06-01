import Foundation

enum WallpaperMode: String, CaseIterable {
    case video      = "video"
    case shader     = "shader"
    case html       = "html"
    case particles  = "particles"

    var displayName: String {
        switch self {
        case .video:     return "🎬  Looping Video"
        case .shader:    return "🌊  Animated Shader"
        case .html:      return "🌐  HTML5 Canvas"
        case .particles: return "✨  Particle Effects"
        }
    }
}
