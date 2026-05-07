import SwiftUI

struct ProPaywallView: View {
    var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "bolt.qrcode")
                        .font(.system(size: 64))
                        .foregroundStyle(.blue)
                        .padding(.top, 20)

                    Text("FlashQR Pro")
                        .font(.largeTitle.bold())

                    Text("One-time purchase. Forever yours.")
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 16) {
                        featureRow(icon: "infinity", text: "Unlimited cards")
                        featureRow(icon: "square.grid.2x2", text: "Home screen widgets")
                        featureRow(icon: "clock.arrow.circlepath", text: "Custom restore timer")
                        featureRow(icon: "doc.on.clipboard", text: "Clipboard import")
                        featureRow(icon: "qrcode", text: "QR code generator")
                        featureRow(icon: "paintpalette", text: "Custom card colors")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)

                    Button(action: purchase) {
                        if isPurchasing {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            Text("Unlock Pro - $1.99")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(isPurchasing)

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
            Text(text)
                .font(.body)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(.green)
        }
    }

    private func purchase() {
        isPurchasing = true
        Task {
            let success = await purchaseManager.purchasePro()
            isPurchasing = false
            if success {
                dismiss()
            }
        }
    }
}
