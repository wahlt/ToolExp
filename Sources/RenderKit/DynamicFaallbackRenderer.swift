//
//  DynamicFallbackRenderer.swift
//  RenderKit
//
//  Specification:
//  • Fallback renderer when high-end pipelines fail or unsupported.
//  • Uses simple MetalKit drawing routines for basic visuals.
//
//  Discussion:
//  On devices lacking ray-tracing or advanced shaders, this renderer
//  ensures the scene still displays, albeit without full effects.
//
//  Rationale:
//  • Graceful degradation avoids blank screens.
//  • Centralizes fallback logic away from primary pipelines.
//
//  Dependencies: MetalKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import MetalKit

public class DynamicFallbackRenderer {
    private let device: MTLDevice
    private let pipelineState: MTLRenderPipelineState

    public init(view: MTKView) throws {
        guard let dev = MTLCreateSystemDefaultDevice() else {
            throw NSError(domain: "DynamicFallbackRenderer", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "No Metal device"])
        }
        self.device = dev
        view.device = dev
        let lib = try dev.makeDefaultLibrary(bundle: .main)
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction   = lib.makeFunction(name: "fallbackVertex")
        desc.fragmentFunction = lib.makeFunction(name: "fallbackFragment")
        desc.colorAttachments[0].pixelFormat = view.colorPixelFormat
        self.pipelineState = try dev.makeRenderPipelineState(descriptor: desc)
    }

    /// Renders a frame using basic geometry.
    public func render(to view: MTKView) {
        guard let drawable = view.currentDrawable,
              let desc     = view.currentRenderPassDescriptor else { return }
        let cmdQ = device.makeCommandQueue()!
        let cmdB = cmdQ.makeCommandBuffer()!
        let enc  = cmdB.makeRenderCommandEncoder(descriptor: desc)!
        enc.setRenderPipelineState(pipelineState)
        // Basic draw: full-screen triangle
        enc.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        enc.endEncoding()
        cmdB.present(drawable)
        cmdB.commit()
    }
}
