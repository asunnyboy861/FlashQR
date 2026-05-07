import SwiftUI

struct QRDisplayView: View {
    let card: QRCard
    @State private var brightnessManager = BrightnessManager()
    @State private var settings = AppSettings()
    @State private var remainingSeconds: Int = 120
    @State private var timer: Timer?
    @Environment(\.dismiss) private var dismiss

    private var totalSeconds: Int {
        Int(settings.autoRestoreInterval)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                if supportsEDR() && (settings.displayMode == .edr || settings.displayMode == .auto) {
                    EDRQRCodeView(
                        qrCodeTextContent: card.content,
                        imageRenderSize: CGSize(width: 280, height: 280)
                    )
                    .frame(width: 280, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    if let qrImage = QRCodeGenerator.generate(from: card.content, size: 280) {
                        Image(uiImage: qrImage)
                            .interpolation(.none)
                            .resizable()
                            .frame(width: 280, height: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Text(card.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(timeString(from: remainingSeconds))
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(.secondary)

                Spacer()

                HStack(spacing: 20) {
                    Button(action: {
                        brightnessManager.restoreBrightness()
                        stopTimer()
                        dismiss()
                    }) {
                        Label("Restore", systemImage: "brightness.solid")
                            .font(.headline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }

                    Button(action: {
                        extendTimer()
                    }) {
                        Label("Extend", systemImage: "clock.arrow.circlepath")
                            .font(.headline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .statusBarHidden(true)
        .onAppear {
            activateDisplay()
        }
        .onDisappear {
            brightnessManager.restoreBrightness()
            stopTimer()
        }
    }

    private func supportsEDR() -> Bool {
        if #available(iOS 16.0, *) {
            return MTLCreateSystemDefaultDevice() != nil
        }
        return false
    }

    private func activateDisplay() {
        if supportsEDR() && (settings.displayMode == .edr || settings.displayMode == .auto) {
            brightnessManager.prepareForDisplay()
        } else {
            brightnessManager.activateFullBrightness()
        }
        remainingSeconds = totalSeconds
        brightnessManager.updateAutoRestoreInterval(settings.autoRestoreInterval)
        startTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                brightnessManager.restoreBrightness()
                stopTimer()
                dismiss()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func extendTimer() {
        remainingSeconds = totalSeconds
        brightnessManager.updateAutoRestoreInterval(settings.autoRestoreInterval)
    }

    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
