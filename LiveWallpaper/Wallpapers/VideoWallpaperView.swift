import AppKit
import AVFoundation

class VideoWallpaperView: NSView {
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var videoURL: URL?
    private var didSetup = false
    private var timeObserver: Any?
    private var sleepObserver: NSObjectProtocol?
    private var wakeObserver:  NSObjectProtocol?

    init(videoURL: URL?) {
        self.videoURL = videoURL
        super.init(frame: .zero)
        wantsLayer = true
        setupPowerObservers()
    }

    required init?(coder: NSCoder) { fatalError() }

    deinit {
        if let o = timeObserver { player?.removeTimeObserver(o) }
        [sleepObserver, wakeObserver].compactMap { $0 }.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        NotificationCenter.default.removeObserver(self)
    }

    // Pause video when display sleeps — saves battery significantly
    private func setupPowerObservers() {
        let nc = NSWorkspace.shared.notificationCenter
        sleepObserver = nc.addObserver(forName: NSWorkspace.screensDidSleepNotification,
                                       object: nil, queue: .main) { [weak self] _ in self?.player?.pause() }
        wakeObserver  = nc.addObserver(forName: NSWorkspace.screensDidWakeNotification,
                                       object: nil, queue: .main) { [weak self] _ in self?.player?.play() }
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard window != nil, !didSetup else { return }
        didSetup = true

        guard let url = videoURL else {
            layer?.backgroundColor = NSColor.black.cgColor
            addPlaceholderLabel()
            return
        }
        setupPlayer(url: url)
    }

    private func setupPlayer(url: URL) {
        guard let rootLayer = self.layer else { return }

        // Security: only allow local file URLs — reject http/https/etc
        guard url.isFileURL else {
            NSLog("VideoWallpaperView: rejected non-file URL %@", url.absoluteString)
            return
        }

        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: false])
        let item  = AVPlayerItem(asset: asset)

        // Reduce memory: don't buffer more than 5 seconds ahead
        item.preferredForwardBufferDuration = 5

        player = AVPlayer(playerItem: item)
        player?.isMuted = true
        // Use hardware decoder path where available
        player?.allowsExternalPlayback = false

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinish),
                                               name: .AVPlayerItemDidPlayToEndTime, object: item)

        let pl = AVPlayerLayer(player: player)
        pl.videoGravity = .resizeAspectFill
        pl.frame = rootLayer.bounds
        rootLayer.addSublayer(pl)
        playerLayer = pl

        player?.play()
    }

    @objc private func playerDidFinish() {
        player?.seek(to: .zero)
        player?.play()
    }

    override func layout() {
        super.layout()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer?.frame = bounds
        CATransaction.commit()
    }

    private func addPlaceholderLabel() {
        let tf = NSTextField(labelWithString: "No video selected.\nUse Browse → My Uploads to add a video.")
        tf.alignment = .center
        tf.textColor = .lightGray
        tf.font = NSFont.systemFont(ofSize: 18, weight: .light)
        tf.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tf)
        NSLayoutConstraint.activate([
            tf.centerXAnchor.constraint(equalTo: centerXAnchor),
            tf.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
