import SwiftUI
import MessageUI

struct ContactSupportView: View {
    @State private var isShowingMailCompose = false
    @State private var mailResult: Result<MFMailComposeResult, Error>?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "envelope")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Contact Support")
                .font(.title2.bold())

            Text("We'd love to hear from you! Send us an email and we'll get back to you as soon as possible.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)

            Button(action: {
                if MFMailComposeViewController.canSendMail() {
                    isShowingMailCompose = true
                } else {
                    if let url = URL(string: "mailto:support@zzoutuo.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }) {
                Text("Send Email")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Contact")
        .sheet(isPresented: $isShowingMailCompose) {
            MailComposeView(isShowing: $isShowingMailCompose, result: $mailResult)
        }
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setToRecipients(["support@zzoutuo.com"])
        controller.setSubject("FlashQR Support")
        controller.mailComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        init(_ parent: MailComposeView) { self.parent = parent }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error { parent.result = .failure(error) }
            else { parent.result = .success(result) }
            parent.isShowing = false
        }
    }
}
