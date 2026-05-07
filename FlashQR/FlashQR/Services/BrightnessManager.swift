import SwiftUI

@Observable
final class BrightnessManager {
    var isDisplaying = false
    private var originalBrightness: CGFloat = 0.5
    private var restoreTimer: Timer?
    private var autoRestoreInterval: TimeInterval = 120

    func prepareForDisplay() {
        originalBrightness = UIScreen.main.brightness
        isDisplaying = true
    }

    func activateFullBrightness() {
        originalBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
        isDisplaying = true
        startAutoRestoreTimer()
    }

    func restoreBrightness() {
        withAnimation(.easeOut(duration: 0.5)) {
            UIScreen.main.brightness = self.originalBrightness
        }
        isDisplaying = false
        invalidateTimer()
    }

    func updateAutoRestoreInterval(_ interval: TimeInterval) {
        autoRestoreInterval = interval
        if isDisplaying {
            startAutoRestoreTimer()
        }
    }

    func handleAppDidEnterBackground() {
        if isDisplaying {
            restoreBrightness()
        }
    }

    private func startAutoRestoreTimer() {
        invalidateTimer()
        restoreTimer = Timer.scheduledTimer(withTimeInterval: autoRestoreInterval, repeats: false) { [weak self] _ in
            self?.restoreBrightness()
        }
    }

    private func invalidateTimer() {
        restoreTimer?.invalidate()
        restoreTimer = nil
    }

    deinit {
        invalidateTimer()
    }
}
