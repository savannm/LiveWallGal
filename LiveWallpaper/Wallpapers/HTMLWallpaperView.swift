import AppKit
import WebKit

class HTMLWallpaperView: WKWebView {

    private var sleepObserver: NSObjectProtocol?
    private var wakeObserver:  NSObjectProtocol?

    init() {
        let config = WKWebViewConfiguration()
        // Security: no JS popups, no remote navigation
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        super.init(frame: .zero, configuration: config)

        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor

        loadHTMLString(htmlContent, baseURL: nil)
        setupPowerObservers()
    }

    required init?(coder: NSCoder) { fatalError() }

    deinit {
        [sleepObserver, wakeObserver].compactMap { $0 }.forEach {
            NSWorkspace.shared.notificationCenter.removeObserver($0)
        }
    }

    private func setupPowerObservers() {
        let nc = NSWorkspace.shared.notificationCenter
        // Pause JS animation loop when display sleeps — zero CPU cost while sleeping
        sleepObserver = nc.addObserver(forName: NSWorkspace.screensDidSleepNotification,
                                       object: nil, queue: .main) { [weak self] _ in
            self?.evaluateJavaScript("document.hidden || pauseAnimation(); 0;", completionHandler: nil)
        }
        wakeObserver = nc.addObserver(forName: NSWorkspace.screensDidWakeNotification,
                                      object: nil, queue: .main) { [weak self] _ in
            self?.evaluateJavaScript("resumeAnimation(); 0;", completionHandler: nil)
        }
    }
}

// MARK: - HTML Content

private let htmlContent = """
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body { width: 100%; height: 100%; overflow: hidden; background: #000; }
  canvas { display: block; }
</style>
</head>
<body>
<canvas id="c"></canvas>
<script>
const canvas = document.getElementById('c');
const ctx    = canvas.getContext('2d');
let W, H, raf = null, running = true;

function resize() { W = canvas.width = window.innerWidth; H = canvas.height = window.innerHeight; }
window.addEventListener('resize', resize);
resize();

const ribbons = Array.from({ length: 10 }, (_, i) => ({
  offset: (i / 10) * Math.PI * 2,
  speed:  0.28 + Math.random() * 0.35,
  amp:    70  + Math.random() * 110,
  freq:   0.004 + Math.random() * 0.003,
  hue:    Math.random() * 360,
  width:  1.5 + Math.random() * 2.5,
  yBase:  Math.random()
}));

let t = 0;
function draw() {
  if (!running) return;
  raf = requestAnimationFrame(draw);

  ctx.fillStyle = 'rgba(0,0,0,0.18)';
  ctx.fillRect(0, 0, W, H);

  for (const r of ribbons) {
    r.hue += 0.25;
    const yC = H * (0.2 + r.yBase * 0.6);
    ctx.beginPath();
    for (let x = 0; x <= W; x += 4) {
      const y = yC
        + Math.sin(x * r.freq + t * r.speed + r.offset) * r.amp
        + Math.sin(x * r.freq * 2 - t * r.speed * 0.7) * r.amp * 0.3;
      x === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
    }
    ctx.strokeStyle = `hsla(${r.hue},100%,65%,0.5)`;
    ctx.lineWidth   = r.width;
    ctx.shadowColor = `hsla(${r.hue},100%,75%,0.7)`;
    ctx.shadowBlur  = 14;
    ctx.stroke();
    ctx.shadowBlur  = 0;
  }

  for (let i = 0; i < 5; i++) {
    const x   = W * 0.5 + Math.cos(t * 0.2 + i * 1.26) * W * 0.35;
    const y   = H * 0.5 + Math.sin(t * 0.15 + i * 1.26) * H * 0.3;
    const r   = 38 + Math.sin(t * 0.5 + i) * 18;
    const hue = (i * 72 + t * 18) % 360;
    const g   = ctx.createRadialGradient(x, y, 0, x, y, r);
    g.addColorStop(0, `hsla(${hue},100%,70%,0.22)`);
    g.addColorStop(1, `hsla(${hue},100%,50%,0)`);
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.fillStyle = g;
    ctx.fill();
  }

  t += 0.015;
}

// Called by Swift on screen sleep/wake
function pauseAnimation()  { running = false; if (raf) cancelAnimationFrame(raf); raf = null; }
function resumeAnimation() { if (!running) { running = true; draw(); } }

draw();
</script>
</body>
</html>
"""
