import SwiftUI

struct SettingsView: View {
    var purchaseManager: PurchaseManager
    @State var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    private let supportURL = "https://asunnyboy861.github.io/FlashQR/support.html"
    private let privacyURL = "https://asunnyboy861.github.io/FlashQR/privacy.html"

    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Picker("Display Mode", selection: $settings.displayMode) {
                        ForEach(DisplayMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Auto-Restore Timer")
                        Slider(value: $settings.autoRestoreInterval, in: 30...600, step: 30) {
                            Text("Timer")
                        }
                        Text("\(Int(settings.autoRestoreInterval / 60)) min \(Int(settings.autoRestoreInterval.truncatingRemainder(dividingBy: 60))) sec")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Pro") {
                    if purchaseManager.isProPurchased {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            Text("Pro Unlocked")
                                .foregroundStyle(.green)
                        }
                    } else {
                        NavigationLink {
                            ProPaywallView(purchaseManager: purchaseManager)
                        } label: {
                            HStack {
                                Image(systemName: "bolt.qrcode")
                                Text("Upgrade to Pro")
                            }
                        }
                    }

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                }

                Section("Support") {
                    Link("Support Page", destination: URL(string: supportURL)!)
                    Link("Privacy Policy", destination: URL(string: privacyURL)!)
                    NavigationLink("Contact Support") {
                        ContactSupportView()
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
