import Metal
import MetalKit
import CoreImage

final class EDRRenderer: NSObject, MTKViewDelegate {
    let imageProvider: (_ scaleFactor: CGFloat, _ _headroom: CGFloat) -> CIImage?
    let device: MTLDevice? = MTLCreateSystemDefaultDevice()
    let commandQueue: MTLCommandQueue?
    let renderContext: CIContext?
    let renderQueue = DispatchSemaphore(value: 3)

    override init() {
        self.imageProvider = { _, _ in nil }
        self.commandQueue = self.device?.makeCommandQueue()
        if let commandQueue {
            self.renderContext = CIContext(mtlCommandQueue: commandQueue, options: [.name: "FlashQR_EDR", .cacheIntermediates: true, .allowLowPower: true])
        } else {
            self.renderContext = nil
        }
        super.init()
    }

    init(imageProvider: @escaping (_ scaleFactor: CGFloat, _ _headroom: CGFloat) -> CIImage?) {
        self.imageProvider = imageProvider
        self.commandQueue = self.device?.makeCommandQueue()
        if let commandQueue {
            self.renderContext = CIContext(mtlCommandQueue: commandQueue, options: [.name: "FlashQR_EDR", .cacheIntermediates: true, .allowLowPower: true])
        } else {
            self.renderContext = nil
        }
        super.init()
    }

    func draw(in view: MTKView) {
        guard let commandQueue else { return }
        _ = renderQueue.wait(timeout: .distantFuture)

        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable else {
            renderQueue.signal()
            return
        }

        commandBuffer.addCompletedHandler { _ in
            self.renderQueue.signal()
        }

        let drawSize = view.drawableSize
        let contentScaleFactor = view.contentScaleFactor

        let destination = CIRenderDestination(
            width: Int(drawSize.width),
            height: Int(drawSize.height),
            pixelFormat: view.colorPixelFormat,
            commandBuffer: commandBuffer,
            mtlTextureProvider: { drawable.texture }
        )

        var headroom: CGFloat = 1.0
        if #available(iOS 16.0, *) {
            headroom = view.window?.screen.currentEDRHeadroom ?? 1.0
        }

        guard var image = self.imageProvider(contentScaleFactor, headroom) else {
            renderQueue.signal()
            return
        }

        let iRect = image.extent
        let backBounds = CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height)
        let shiftX = round((backBounds.size.width + iRect.origin.x - iRect.size.width) * 0.5)
        let shiftY = round((backBounds.size.height + iRect.origin.y - iRect.size.height) * 0.5)
        image = image.transformed(by: CGAffineTransform(translationX: shiftX, y: shiftY))
        image = image.composited(over: .black)

        guard let renderContext else { return }
        _ = try? renderContext.startTask(toRender: image, from: backBounds, to: destination, at: CGPoint.zero)

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
