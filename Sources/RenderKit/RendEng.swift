//
//  RendEng.swift
//  RenderKit
//
//  Specification:
//  • Core renderer using Metal command buffers & encoders.
//  • Supports multiple mesh types, textures, and post-effects.
//
//  Discussion:
//  Replaces DynamicFallbackRenderer when full feature set available.
//
//  Rationale:
//  • Central place for draw-call management and GPU state setup.
//  Dependencies: MetalKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import MetalKit

public class RendEng {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    public init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
    }

    /// Renders an array of meshes into the given MTKView.
    public func render(meshes: [RenderableMesh], in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let desc     = view.currentRenderPassDescriptor else { return }
        let buf = commandQueue.makeCommandBuffer()!
        let enc = buf.makeRenderCommandEncoder(descriptor: desc)!
        for mesh in meshes {
            // Bind mesh.pipelineState, vertexBuffers, textures…
            enc.setRenderPipelineState(mesh.pipelineState)
            enc.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
            enc.drawPrimitives(type: .triangle,
                               vertexStart: 0,
                               vertexCount: mesh.vertexCount)
        }
        enc.endEncoding()
        buf.present(drawable)
        buf.commit()
    }
}
