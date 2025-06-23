//
//  GlobalIllumination.swift
//  RenderKit
//
//  Specification:
//  • Computes indirect lighting via sparse voxel octree tracing.
//  • Updates a GI buffer each frame for fast lookup in shaders.
//
//  Discussion:
//  Realistic scene lighting requires bounced light; this module
//  precomputes coarse GI using ray-marching in a voxel grid.
//
//  Rationale:
//  • Improves visual fidelity over direct illumination only.
//  • Runs as a background pass to avoid frame drops.
//
//  Dependencies: Metal
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Metal

public class GlobalIllumination {
    private let device: MTLDevice
    private let pipeline: MTLComputePipelineState
    private let gridBuffer: MTLBuffer

    public init(device: MTLDevice, gridSize: Int) throws {
        self.device = device
        let lib = try device.makeDefaultLibrary(bundle: .main)
        guard let fn = lib.makeFunction(name: "giComputeKernel") else {
            throw NSError(domain: "GlobalIllumination", code: -1, userInfo: nil)
        }
        pipeline = try device.makeComputePipelineState(function: fn)
        gridBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * gridSize * gridSize * gridSize,
                                       options: .storageModePrivate)!
    }

    /// Executes the GI compute pass.
    public func compute(commandBuffer: MTLCommandBuffer, gridSize: Int) {
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipeline)
        encoder.setBuffer(gridBuffer, offset: 0, index: 0)
        let threads = MTLSize(width: 8, height: 8, depth: 8)
        let groups  = MTLSize(width: (gridSize+7)/8,
                              height:(gridSize+7)/8,
                              depth:(gridSize+7)/8)
        encoder.dispatchThreadgroups(groups, threadsPerThreadgroup: threads)
        encoder.endEncoding()
    }
}
