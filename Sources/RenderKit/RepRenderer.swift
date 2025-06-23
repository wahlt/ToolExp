//
//  RepRenderer.swift
//  RenderKit
//
//  Specification:
//  • Specialized renderer for Rep graphs: draws nodes & edges.
//  • Supports 2D force-layout and 3D “bubble” views.
//
//  Discussion:
//  Visualizing RepStruct requires mapping cell positions and
//  port links into screen-space primitives.
//
//  Rationale:
//  • Separate from ArtEngine to allow different visual styles.
//  Dependencies: MetalKit, RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import MetalKit
import RepKit

public class RepRenderer {
    private let device: MTLDevice
    private let pipeline: MTLRenderPipelineState

    public init(view: MTKView) throws {
        guard let dev = MTLCreateSystemDefaultDevice(),
              let lib = try? dev.makeDefaultLibrary(bundle: .main),
              let vf = lib.makeFunction(name: "repVertex"),
              let ff = lib.makeFunction(name: "repFragment") else {
            throw NSError(domain: "RepRenderer", code: -1, userInfo: nil)
        }
        self.device = dev
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction   = vf
        desc.fragmentFunction = ff
        desc.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipeline = try dev.makeRenderPipelineState(descriptor: desc)
    }

    /// Draws the given RepStruct into the view.
    public func render(rep: RepStruct, in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let desc     = view.currentRenderPassDescriptor else { return }
        let buf = device.makeCommandQueue()!.makeCommandBuffer()!
        let enc = buf.makeRenderCommandEncoder(descriptor: desc)!
        enc.setRenderPipelineState(pipeline)
        // Convert rep.cells → vertex arrays & draw lines
        // TODO: full layout & indexing logic
        enc.endEncoding()
        buf.present(drawable)
        buf.commit()
    }
}
