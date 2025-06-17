//
//  RendEng.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RendEng.swift
// RenderKit — Basic GPU renderer stub (Metal2 fallback).
//
// Responsibilities:
//  • Provide minimal unlit mesh+color rendering.
//  • Serve as a reference for more advanced pipelines.
//

import Foundation
import MetalKit
import RepKit

public final class RendEng: Renderer {
    private let device: MTLDevice
    private let queue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState

    public init(view: MTKView) {
        self.device = view.device!
        self.queue = device.makeCommandQueue()!
        // TODO: compile a basic vertex+fragment shader into `pipelineState`
        self.pipelineState = try! device.makeRenderPipelineState(
            descriptor: MTLRenderPipelineDescriptor()
        )
    }

    public func render(_ rep: RepStruct, in view: MTKView) {
        guard let cmdBuf = queue.makeCommandBuffer(),
              let rpd   = view.currentRenderPassDescriptor,
              let enc   = cmdBuf.makeRenderCommandEncoder(descriptor: rpd)
        else { return }

        enc.setRenderPipelineState(pipelineState)
        // TODO: set vertex/index buffers and draw each cell’s mesh
        enc.endEncoding()
        cmdBuf.present(view.currentDrawable!)
        cmdBuf.commit()
    }
}
