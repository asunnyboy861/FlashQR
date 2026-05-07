import SwiftUI
import CoreImage.CIFilterBuiltins

struct EDRQRCodeView: View {
    var qrCodeTextContent: String
    var imageRenderSize: CGSize
    var qrCodeScaleFactor: CGFloat = 15

    var body: some View {
        let renderer = EDRRenderer(imageProvider: { scaleFactor, headroom in
            guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
            let inputData = qrCodeTextContent.data(using: .utf8)
            qrFilter.setValue(inputData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")

            guard let image = qrFilter.outputImage else { return nil }
            let sizeTransform = CGAffineTransform(scaleX: qrCodeScaleFactor, y: qrCodeScaleFactor)
            let qrImage = image.transformed(by: sizeTransform)

            let maxRGB = headroom
            guard let EDRColorSpace = CGColorSpace(name: CGColorSpace.extendedLinearSRGB),
                  let maxFillColor = CIColor(red: maxRGB, green: maxRGB, blue: maxRGB, colorSpace: EDRColorSpace) else { return nil }

            let fillImage = CIImage(color: maxFillColor)
            let maskFilter = CIFilter.blendWithMask()
            maskFilter.maskImage = qrImage
            maskFilter.inputImage = fillImage

            guard let combinedImage = maskFilter.outputImage else { return nil }
            return combinedImage.cropped(to: CGRect(
                x: 0, y: 0,
                width: imageRenderSize.width * scaleFactor,
                height: imageRenderSize.height * scaleFactor
            ))
        })

        EDRMetalView(renderer: renderer)
    }
}
