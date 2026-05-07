import Foundation
import SwiftData

enum QRType: String, Codable {
    case qr
    case aztec
    case pdf417
    case code128
    case image
}

@Model
final class QRCard {
    var id: UUID = UUID()
    var name: String = ""
    var content: String = ""
    var type: QRType = QRType.qr
    @Attribute(.externalStorage) var imageData: Data?
    var colorHex: String?
    var isFavorite: Bool = false
    var displayCount: Int = 0
    var lastDisplayedAt: Date?
    var createdAt: Date = Date()

    init(name: String, content: String, type: QRType = .qr, imageData: Data? = nil, colorHex: String? = nil) {
        self.id = UUID()
        self.name = name
        self.content = content
        self.type = type
        self.imageData = imageData
        self.colorHex = colorHex
        self.isFavorite = false
        self.displayCount = 0
        self.lastDisplayedAt = nil
        self.createdAt = Date()
    }
}
