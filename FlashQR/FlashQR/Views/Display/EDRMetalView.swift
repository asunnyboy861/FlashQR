import SwiftUI
import MetalKit

struct EDRMetalView: UIViewRepresentable {
    var renderer: EDRRenderer

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: renderer.device)
        view.preferredFramesPerSecond = 10
        view.framebufferOnly = false
        view.delegate = renderer

        if let layer = view.layer as? CAMetalLayer {
            if #available(iOS 16.0, *) {
                layer.wantsExtendedDynamicRangeContent = true
            }
            layer.colorspace = CGColorSpace(name: CGColorSpace.extendedLinearDisplayP3)
            view.colorPixelFormat = MTLPixelFormat.rgba16Float
        }
        return view
    }

    func updateUIView(_ view: MTKView, context: Context) {
        view.delegate = renderer
    }
}
