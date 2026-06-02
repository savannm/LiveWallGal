import AppKit
import Metal
import MetalKit

// MARK: - Metal Shader Source

private let shaderSource = """
#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertexShader(uint vid [[vertex_id]]) {
    float2 positions[3] = {
        float2(-1.0, -1.0),
        float2( 3.0, -1.0),
        float2(-1.0,  3.0)
    };
    VertexOut out;
    out.position = float4(positions[vid], 0.0, 1.0);
    out.uv = (positions[vid] + 1.0) * 0.5;
    return out;
}

// Pseudo-random hash function for star scattering
float hash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123);
}

fragment float4 fragmentShader(VertexOut vin [[stage_in]],
                                constant float &time [[buffer(0)]]) {
    float2 uv = vin.uv;
    float2 p = uv * 2.0 - 1.0;
    float t = time * 0.4;

    float wave1 = sin(p.x * 3.0 + t) * 0.3;
    float wave2 = sin(p.x * 5.0 - t * 1.3 + 1.0) * 0.2;
    float wave3 = sin(p.x * 2.0 + t * 0.7 + 2.0) * 0.15;
    float band = smoothstep(0.08, 0.0, abs(p.y - wave1 - wave2 - wave3));

    float3 col1 = float3(0.0, 0.8, 0.6);
    float3 col2 = float3(0.2, 0.3, 1.0);
    float3 col3 = float3(0.8, 0.1, 0.9);
    float blend = sin(t + uv.x * 2.0) * 0.5 + 0.5;
    float3 auroraColor = mix(mix(col1, col2, blend), col3, sin(t * 0.5) * 0.5 + 0.5);

    // Scattered organic stars — smooth gaussian dot, no column-streak artefact
    float2 gridId = floor(uv * 60.0);
    float2 gridUv = fract(uv * 60.0);
    // Place each star at a pseudo-random position inside its cell
    float2 starPos = float2(hash(gridId + 0.1), hash(gridId + 7.3));
    float dist = length(gridUv - starPos);
    // Only ~4 % of cells contain a visible star
    float starRand = hash(gridId + 45.2);
    float visible = step(0.96, starRand);
    // Smooth gaussian glow — never reaches cell boundary, so no vertical artefacts
    float glow = exp(-dist * dist * 600.0);
    float starBlink = sin(t * (1.2 + starRand * 2.5) + starRand * 6.28) * 0.45 + 0.55;
    float star = visible * glow * starBlink * (0.4 + starRand * 0.6);

    float3 sky = float3(0.01, 0.02, 0.05) + float3(0.0, 0.03, 0.08) * (1.0 - uv.y);
    float3 finalColor = sky + auroraColor * band * 1.5 + float3(star * 0.9);
    return float4(finalColor, 1.0);
}
"""

// MARK: - View

class ShaderWallpaperView: MTKView, MTKViewDelegate {
    private var commandQueue: MTLCommandQueue?
    private var pipelineState: MTLRenderPipelineState?
    private var startTime = Date()

    // Observers for power/display sleep management
    private var sleepObserver: NSObjectProtocol?
    private var wakeObserver: NSObjectProtocol?
    private var powerObserver: NSObjectProtocol?

    init() {
        let device = MTLCreateSystemDefaultDevice()
        super.init(frame: .zero, device: device)
        self.delegate = self
        self.framebufferOnly = true
        // 30 fps is imperceptible on a wallpaper and halves GPU load vs 60
        self.preferredFramesPerSecond = 30
        self.enableSetNeedsDisplay = false
        self.isPaused = false
        setupMetal()
        setupPowerObservers()
    }

    required init(coder: NSCoder) { fatalError() }

    deinit {
        [sleepObserver, wakeObserver, powerObserver].compactMap { $0 }.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }

    // MARK: Power management — pause when display sleeps or on battery low
    private func setupPowerObservers() {
        let nc = NSWorkspace.shared.notificationCenter
        sleepObserver = nc.addObserver(forName: NSWorkspace.screensDidSleepNotification,
                                       object: nil, queue: .main) { [weak self] _ in
            self?.isPaused = true
        }
        wakeObserver = nc.addObserver(forName: NSWorkspace.screensDidWakeNotification,
                                      object: nil, queue: .main) { [weak self] _ in
            self?.isPaused = false
        }
        // Throttle to 15 fps on Low Power Mode
        powerObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil, queue: .main) { [weak self] _ in
            self?.preferredFramesPerSecond =
                ProcessInfo.processInfo.isLowPowerModeEnabled ? 15 : 30
        }
    }

    private func setupMetal() {
        guard let device = device else { return }
        commandQueue = device.makeCommandQueue()
        do {
            let library = try device.makeLibrary(source: shaderSource, options: nil)
            let desc = MTLRenderPipelineDescriptor()
            desc.vertexFunction   = library.makeFunction(name: "vertexShader")
            desc.fragmentFunction = library.makeFunction(name: "fragmentShader")
            desc.colorAttachments[0].pixelFormat = colorPixelFormat
            pipelineState = try device.makeRenderPipelineState(descriptor: desc)
        } catch {
            // Surface error without crashing; wallpaper just shows black
            NSLog("ShaderWallpaperView Metal setup failed: %@", error.localizedDescription)
        }
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard
            let drawable  = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor,
            let cmdBuffer  = commandQueue?.makeCommandBuffer(),
            let encoder    = cmdBuffer.makeRenderCommandEncoder(descriptor: descriptor),
            let pipeline   = pipelineState
        else { return }

        var time = Float(Date().timeIntervalSince(startTime))
        encoder.setRenderPipelineState(pipeline)
        encoder.setFragmentBytes(&time, length: MemoryLayout<Float>.size, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        cmdBuffer.present(drawable)
        cmdBuffer.commit()
    }
}
