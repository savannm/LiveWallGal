import Foundation
import AppKit

/// Tracks subscription status. Stripe webhook → your server → this app via URL scheme or polling.
/// For a standalone Mac app (outside App Store), Stripe Checkout is the correct integration:
/// 1. User clicks Subscribe → opens Stripe Checkout in their browser
/// 2. On success, Stripe redirects to backdrop://success?session_id=xxx
/// 3. App catches the URL, verifies with your backend, stores the subscription token
final class SubscriptionManager {

    static let shared = SubscriptionManager()

    // ── CONFIGURE THESE ───────────────────────────────────────────────────────
    /// Your Stripe Checkout payment link (from Stripe Dashboard → Payment Links)
    static let stripePaymentLink = "https://buy.stripe.com/YOUR_PAYMENT_LINK"
    /// Price: shown in UI only — match your Stripe product
    static let priceDisplay      = "$4.99 / month"
    /// Your backend endpoint that verifies a Stripe Checkout session
    static let verifyEndpoint    = "https://your-server.com/verify-session"
    // ─────────────────────────────────────────────────────────────────────────

    private let tokenKey    = "com.livewallpaper.subscriptionToken"
    private let expiryKey   = "com.livewallpaper.subscriptionExpiry"
    private let trialKey    = "com.livewallpaper.trialStartDate"

    var onStatusChange: ((Bool) -> Void)?

    private(set) var isSubscribed: Bool = false {
        didSet { if oldValue != isSubscribed { onStatusChange?(isSubscribed) } }
    }

    // Free tier: 7-day trial, 3 preset wallpapers, no uploads
    var isInTrial: Bool {
        guard let start = trialStart else { return false }
        return Date().timeIntervalSince(start) < 7 * 86400
    }
    var trialDaysRemaining: Int {
        guard let start = trialStart else { return 0 }
        let elapsed = Date().timeIntervalSince(start)
        return max(0, 7 - Int(elapsed / 86400))
    }

    private var subscriptionToken: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    private var subscriptionExpiry: Date? {
        get {
            guard let ts = UserDefaults.standard.object(forKey: expiryKey) as? Double else { return nil }
            return Date(timeIntervalSince1970: ts)
        }
        set { UserDefaults.standard.set(newValue?.timeIntervalSince1970, forKey: expiryKey) }
    }
    private var trialStart: Date? {
        get {
            if let ts = UserDefaults.standard.object(forKey: trialKey) as? Double {
                return Date(timeIntervalSince1970: ts)
            }
            // First launch — start trial now
            let now = Date()
            UserDefaults.standard.set(now.timeIntervalSince1970, forKey: trialKey)
            return now
        }
    }

    private init() {
        refreshStatus()
    }

    // MARK: - Status

    func refreshStatus() {
        if let expiry = subscriptionExpiry, expiry > Date() {
            isSubscribed = true
        } else {
            isSubscribed = false
            subscriptionToken = nil      // clear stale token
        }
    }

    // MARK: - Open Stripe Checkout

    func openCheckout() {
        guard let url = URL(string: Self.stripePaymentLink) else { return }
        NSWorkspace.shared.open(url)
    }

    // MARK: - Handle redirect (called from AppDelegate on URL open)
    // Register URL scheme "backdrop" in Info.plist → CFBundleURLSchemes

    func handleCallbackURL(_ url: URL) {
        guard url.scheme == "backdrop",
              url.host   == "success",
              let comps   = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let sessionId = comps.queryItems?.first(where: { $0.name == "session_id" })?.value
        else { return }

        verifySession(sessionId)
    }

    // MARK: - Verify with backend

    private func verifySession(_ sessionId: String) {
        guard let endpoint = URL(string: Self.verifyEndpoint) else { return }
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: ["session_id": sessionId])

        URLSession.shared.dataTask(with: req) { [weak self] data, _, _ in
            guard let self, let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let active  = json["active"]  as? Bool, active,
                  let expiry  = json["expiry"]  as? Double,
                  let token   = json["token"]   as? String
            else { return }

            DispatchQueue.main.async {
                self.subscriptionToken  = token
                self.subscriptionExpiry = Date(timeIntervalSince1970: expiry)
                self.refreshStatus()
            }
        }.resume()
    }

    // MARK: - Manage / Cancel (opens Stripe Customer Portal)

    func openCustomerPortal() {
        let portalURL = "https://billing.stripe.com/p/login/YOUR_PORTAL_LINK"
        guard let url = URL(string: portalURL) else { return }
        NSWorkspace.shared.open(url)
    }

    // MARK: - Feature gating helpers

    /// Returns true if the user can access a paid feature
    func canAccessPremium() -> Bool {
        return isSubscribed || isInTrial
    }

    /// Returns true if the user can access folder scanning (premium feature)
    func canScanFolders() -> Bool { canAccessPremium() }

    /// Returns true if the user can upload/apply custom videos (premium feature)
    func canUseCustomVideos() -> Bool { canAccessPremium() }
}
