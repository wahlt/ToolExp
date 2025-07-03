//
//  GPUOverlayComposer.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  GPUOverlayComposer.swift
//  UXKit
//
//  1. Purpose
//     Draws gesture-trail overlays via a Metal compute shader.
// 2. Dependencies
//     MetalKit
// 3. Overview
//     Encodes point buffers and dispatches the `composeOverlay` kernel.
// 4. Usage
//     `composer.compose(points: pts, into: texture)`
// 5. Notes
//     Assumes `OverlayCompose.metal` is in default library.

import MetalKit

public final class GPUOverlayComposer {
    private let device: MTLDevice
    private let pipeline: MTLComputePipelineState
    private let queue: MTLCommandQueue

    public init(device: MTLDevice) {
        self.device = device
        queue = device.makeCommandQueue()!
        let lib = device.makeDefaultLibrary()!
        let fn  = lib.makeFunction(name: "composeOverlay")!
        pipeline = try! device.makeComputePipelineState(function: fn)
    }

    /// Renders glowing trails for `points` into `texture`.
    public func compose(points: [SIMD2<Float>], into texture: MTLTexture) {
        guard !points.isEmpty else { return }
        var cnt = UInt32(points.count)
        let ptBuf = device.makeBuffer(bytes: points,
                                      length: MemoryLayout<SIMD2<Float>>.stride * points.count,
                                      options: [])!
        let cntBuf = device.makeBuffer(bytes: &cnt,
                                       length: MemoryLayout<UInt32>.size,
                                       options: [])!

        let cmd = queue.makeCommandBuffer()!
        let enc = cmd.makeComputeCommandEncoder()!
        enc.setComputePipelineState(pipeline)
        enc.setBuffer(ptBuf, offset: 0, index: 0)
        enc.setBuffer(cntBuf, offset: 0, index: 1)
        enc.setTexture(texture, index: 0)

        let w = pipeline.threadExecutionWidth
        let h = pipeline.maxTotalThreadsPerThreadgroup / w
        let tg = MTLSize(width: w, height: h, depth: 1)
        let gw = Int(ceil(Float(texture.width)  / Float(w)))
        let gh = Int(ceil(Float(texture.height) / Float(h)))
        enc.dispatchThreadgroups(MTLSize(width: gw, height: gh, depth: 1),
                                 threadsPerThreadgroup: tg)
        enc.endEncoding()
        cmd.commit()
    }
}
