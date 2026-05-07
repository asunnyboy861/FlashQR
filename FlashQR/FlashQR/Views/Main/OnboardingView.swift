import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    var settings: AppSettings

    private let pages = [
        (title: "Show QR Codes, Auto Bright", subtitle: "FlashQR automatically brightens your QR code for easy scanning", icon: "qrcode.viewfinder"),
        (title: "Auto Restore, No Worries", subtitle: "Brightness returns to your original setting when you're done", icon: "arrow.uturn.backward.circle"),
        (title: "Import from Photos", subtitle: "Add QR codes from your photo library, camera, or type manually", icon: "photo.on.rectangle")
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: pages[currentPage].icon)
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text(pages[currentPage].title)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(pages[currentPage].subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }

                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        withAnimation { settings.hasCompletedOnboarding = true }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}
