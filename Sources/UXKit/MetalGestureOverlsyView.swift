//
//  MetalGestureOverlsyView.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  MetalGestureOverlayView.swift
//  UXKit
//
//  1. Purpose
//     SwiftUI wrapper for a Metal view that renders gesture trails.
// 2. Dependencies
//     SwiftUI, MetalKit
// 3. Overview
//     Hosts an `MTKView` and uses `GPUOverlayComposer` internally.
// 4. Usage
//     `MetalGestureOverlayView(points: $points)`
// 5. Notes
//     Exposes a binding to feed in new stroke points.

import SwiftUI
import MetalKit

public struct MetalGestureOverlayView: UIViewRepresentable {
    @Binding public var points: [SIMD2<Float>]

    public func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.isPaused = true
        view.enableSetNeedsDisplay = true
        context.coordinator.setup(in: view)
        return view
    }

    public func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.update(points: points)
        uiView.setNeedsDisplay()
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public class Coordinator: NSObject, MTKViewDelegate {
        private var composer: GPUOverlayComposer!
        private var texture: MTLTexture?
        private var points: [SIMD2<Float>] = []

        func setup(in view: MTKView) {
            guard let dev = view.device else { return }
            composer = GPUOverlayComposer(device: dev)
            let desc = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: .rgba8Unorm,
                width: Int(view.drawableSize.width),
                height: Int(view.drawableSize.height),
                mipmapped: false
            )
            desc.usage = [.shaderWrite, .shaderRead]
            texture = dev.makeTexture(descriptor: desc)
            view.delegate = self
        }

        func update(points: [SIMD2<Float>]) {
            self.points = points
        }

        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // recreate texture on size change
            setup(in: view)
        }

        public func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let tex = texture else { return }
            // clear overlay
            let cmdQ = view.device!.makeCommandQueue()!
            let cmd  = cmdQ.makeCommandBuffer()!
            let blit = cmd.makeBlitCommandEncoder()!
            blit.fill(buffer: tex.buffer!,
                      range: 0..<tex.buffer!.length,
                      value: 0)
            blit.endEncoding()
            cmd.commit()
            // compose trails
            composer.compose(points: points, into: tex)

            // blit to screen
            let cmd2  = cmdQ.makeCommandBuffer()!
            let blit2 = cmd2.makeBlitCommandEncoder()!
            blit2.copy(from: tex,
                       sourceSlice: 0, sourceLevel: 0,
                       sourceOrigin: MTLOrigin(),
                       sourceSize: MTLSize(width: tex.width, height: tex.height, depth:1),
                       to: drawable.texture,
                       destinationSlice: 0, destinationLevel: 0,
                       destinationOrigin: MTLOrigin())
            blit2.endEncoding()
            cmd2.present(drawable)
            cmd2.commit()
        }
    }
}
