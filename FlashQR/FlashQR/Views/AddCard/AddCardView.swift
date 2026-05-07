import SwiftUI
import SwiftData
import PhotosUI

struct AddCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var purchaseManager: PurchaseManager
    var cardCount: Int

    @State private var cardName = ""
    @State private var cardContent = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showingCamera = false
    @State private var showingProPaywall = false
    @State private var detectedContent: String?
    @State private var detectedType: QRType = .qr

    private var isOverFreeLimit: Bool {
        !purchaseManager.isProPurchased && cardCount >= 3
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if isOverFreeLimit {
                        proLimitBanner
                    }

                    addMethodSection

                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Card Name")
                            .font(.headline)
                        TextField("e.g. CVS Pharmacy", text: $cardName)
                            .textFieldStyle(.roundedBorder)

                        Text("QR Code Content")
                            .font(.headline)
                        TextField("Enter or paste QR code content", text: $cardContent)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.horizontal)

                    Button(action: saveCard) {
                        Text("Save Card")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canSave ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!canSave)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task { await handlePhotoSelection(newValue) }
            }
            .sheet(isPresented: $showingProPaywall) {
                ProPaywallView(purchaseManager: purchaseManager)
            }
        }
    }

    private var canSave: Bool {
        !cardName.isEmpty && !cardContent.isEmpty && !isOverFreeLimit
    }

    private var addMethodSection: some View {
        VStack(spacing: 12) {
            Button(action: { showingCamera = true }) {
                Label("Scan QR Code", systemImage: "camera")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("From Photos", systemImage: "photo")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: pasteFromClipboard) {
                Label("From Clipboard", systemImage: "doc.on.clipboard")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!purchaseManager.isProPurchased)
            .overlay(alignment: .topTrailing) {
                if !purchaseManager.isProPurchased {
                    Text("PRO")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: 8, y: -8)
                }
            }
        }
        .padding(.horizontal)
    }

    private var proLimitBanner: some View {
        VStack(spacing: 8) {
            Text("Free limit reached (3 cards)")
                .font(.subheadline.bold())
            Button("Upgrade to Pro") {
                showingProPaywall = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    private func saveCard() {
        let card = QRCard(name: cardName, content: cardContent, type: detectedType)
        modelContext.insert(card)
        dismiss()
    }

    private func pasteFromClipboard() {
        if let clipboardContent = UIPasteboard.general.string {
            cardContent = clipboardContent
        }
    }

    private func handlePhotoSelection(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return }

        let importer = PhotoQRImporter()
        if let content = importer.detectQRCode(from: image) {
            cardContent = content
            if let type = importer.detectBarcodeType(from: image) {
                detectedType = type
            }
        }
    }
}
