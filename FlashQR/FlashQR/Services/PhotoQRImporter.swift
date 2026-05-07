import SwiftUI
import PhotosUI
import Vision

struct PhotoQRImporter {
    func detectQRCode(from image: UIImage) -> String? {
        guard let cgImage = image.cgImage else { return nil }

        let request = VNDetectBarcodesRequest()
        request.symbologies = [.qr, .aztec, .pdf417, .code128]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])

        guard let observations = request.results as? [VNBarcodeObservation],
              let firstObservation = observations.first,
              let payloadString = firstObservation.payloadStringValue else {
            return nil
        }

        return payloadString
    }

    func detectBarcodeType(from image: UIImage) -> QRType? {
        guard let cgImage = image.cgImage else { return nil }

        let request = VNDetectBarcodesRequest()
        request.symbologies = [.qr, .aztec, .pdf417, .code128]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])

        guard let observation = request.results?.first as? VNBarcodeObservation else {
            return nil
        }

        switch observation.symbology {
        case .qr: return .qr
        case .aztec: return .aztec
        case .pdf417: return .pdf417
        case .code128: return .code128
        default: return .qr
        }
    }
}
