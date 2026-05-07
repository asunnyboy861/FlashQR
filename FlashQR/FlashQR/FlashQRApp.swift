import SwiftUI
import SwiftData

@main
struct FlashQRApp: App {
    var body: some Scene {
        WindowGroup {
            CardListView()
        }
        .modelContainer(for: QRCard.self)
    }
}
