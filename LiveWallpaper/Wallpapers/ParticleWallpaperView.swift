import AppKit
import SpriteKit

class ParticleWallpaperView: SKView {
    private var lastSize: CGSize = .zero
    private var sleepObserver: NSObjectProtocol?
    private var wakeObserver:  NSObjectProtocol?

    init() {
        super.init(frame: .zero)
        allowsTransparency = false
        ignoresSiblingOrder = true
        showsFPS = false
        showsNodeCount = false
        // 30 fps — imperceptible on desktop, saves ~50% CPU vs default 60
        preferredFramesPerSecond = 30
        setupPowerObservers()
    }

    required init?(coder: NSCoder) { fatalError() }

    deinit {
        [sleepObserver, wakeObserver].compactMap { $0 }.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }

    private func setupPowerObservers() {
        let nc = NSWorkspace.shared.notificationCenter
        sleepObserver = nc.addObserver(forName: NSWorkspace.screensDidSleepNotification,
                                       object: nil, queue: .main) { [weak self] _ in self?.isPaused = true }
        wakeObserver  = nc.addObserver(forName: NSWorkspace.screensDidWakeNotification,
                                       object: nil, queue: .main) { [weak self] _ in self?.isPaused = false }
    }

    override func layout() {
        super.layout()
        guard bounds.width > 0, bounds.size != lastSize else { return }
        lastSize = bounds.size
        scene?.removeAllActions()
        scene?.removeAllChildren()
        let s = ParticleScene(size: bounds.size)
        s.scaleMode = .resizeFill
        s.backgroundColor = .black
        presentScene(s)
    }
}

// MARK: - Scene

class ParticleScene: SKScene {

    private static let sharedTexture: SKTexture = {
        let size = CGSize(width: 8, height: 8)
        let img = NSImage(size: size)
        img.lockFocus()
        if let ctx = NSGraphicsContext.current?.cgContext {
            ctx.setFillColor(NSColor.white.cgColor)
            ctx.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
        img.unlockFocus()
        return SKTexture(image: img)
    }()

    override func didMove(to view: SKView) {
        backgroundColor = NSColor.black
        addStarField()
        addAmbientDust()
        addFirework()
        // Reduced frequency — was 2.5s, now 4s between fireworks to cut node churn
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 4.0, withRange: 1.5),
            SKAction.run { [weak self] in self?.addFirework() }
        ])))
    }

    private func addStarField() {
        let e = SKEmitterNode()
        e.particleTexture         = ParticleScene.sharedTexture
        // birthRate 2 means ~120 stars alive at a time (lifetime 60s) — cheap
        e.particleBirthRate       = 2
        e.particleLifetime        = 60
        e.particleLifetimeRange   = 20
        e.emissionAngleRange      = .pi * 2
        e.particleSpeed           = 0.2
        e.particleSpeedRange      = 0.5
        e.particleAlpha           = 0.8
        e.particleAlphaRange      = 0.4
        e.particleAlphaSpeed      = -0.005
        e.particleScale           = 0.04
        e.particleScaleRange      = 0.06
        e.particleColor           = .white
        e.particleColorBlendFactor = 1
        e.position                = CGPoint(x: size.width / 2, y: size.height / 2)
        e.particlePositionRange   = CGVector(dx: size.width, dy: size.height)
        addChild(e)
    }

    private func addFirework() {
        let x   = CGFloat.random(in: size.width  * 0.15 ... size.width  * 0.85)
        let y   = CGFloat.random(in: size.height * 0.35 ... size.height * 0.85)
        let hue = CGFloat.random(in: 0...1)
        let col = NSColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)

        let trail = emitter(birth: 40, life: 0.4, speed: 0, scale: 0.025, color: col, alpha: 0.5)
        trail.position = CGPoint(x: x, y: 40)
        addChild(trail)

        let rise = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.9)
        rise.timingMode = .easeOut
        trail.run(SKAction.sequence([rise, SKAction.run { [weak self, weak trail] in
            trail?.particleBirthRate = 0
            trail?.run(SKAction.sequence([.wait(forDuration: 1), .removeFromParent()]))
            self?.burst(at: CGPoint(x: x, y: y), color: col)
        }]))
    }

    private func burst(at point: CGPoint, color: NSColor) {
        // Reduced from 600 → 300 birth rate, still looks great, half the particles
        let e = emitter(birth: 300, life: 2.0, speed: 160, scale: 0.045, color: color, alpha: 1)
        e.particleSpeedRange   = 100
        e.emissionAngleRange   = .pi * 2
        e.particleAlphaSpeed   = -0.5
        e.yAcceleration        = -50
        e.position             = point
        e.zPosition            = 2
        addChild(e)
        e.run(SKAction.sequence([
            .wait(forDuration: 0.04),
            .run { e.particleBirthRate = 0 },
            .wait(forDuration: 2.5),
            .removeFromParent()
        ]))
    }

    private func addAmbientDust() {
        let e = emitter(birth: 5, life: 14, speed: 12, scale: 0.02,
                        color: NSColor(hue: 0.6, saturation: 0.5, brightness: 0.9, alpha: 1), alpha: 0.2)
        e.emissionAngle       = .pi / 2
        e.emissionAngleRange  = .pi / 5
        e.particleSpeedRange  = 6
        e.position            = CGPoint(x: size.width / 2, y: 0)
        e.particlePositionRange = CGVector(dx: size.width, dy: 0)
        addChild(e)
    }

    private func emitter(birth: CGFloat, life: CGFloat, speed: CGFloat,
                         scale: CGFloat, color: NSColor, alpha: CGFloat) -> SKEmitterNode {
        let e = SKEmitterNode()
        e.particleTexture          = ParticleScene.sharedTexture
        e.particleBirthRate        = birth
        e.particleLifetime         = life
        e.particleLifetimeRange    = life * 0.2
        e.particleSpeed            = speed
        e.particleAlpha            = alpha
        e.particleScale            = scale
        e.particleColor            = color
        e.particleColorBlendFactor = 1
        e.particleBlendMode        = .add
        return e
    }
}
