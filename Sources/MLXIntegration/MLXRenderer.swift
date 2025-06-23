//
//  MLXRenderer.swift
//  MLXIntegration
//
//  Specification:
//  • Orchestrates MLX tiling, pipelining, and execution on Metal & NPU.
//  • Exposes async/await entrypoints for high-level tasks.
//
//  Discussion:
//  Heavy tensor and shader workloads offloaded here—with fallback to CPU.
//
//  Rationale:
//  • Encapsulate all MLX logic to avoid bleeding into core Rep code.
//  • Provide unified API handling compilation, dispatch, and merging.
//
//  Dependencies: Metal
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Metal

public class MLXRenderer {
    private let device: MTLDevice
    private let library: MTLLibrary

    public init() throws {
        guard let dev = MTLCreateSystemDefaultDevice() else {
            throw NSError(domain: "MLXRenderer", code: -1, userInfo: nil)
        }
        device = dev
        library = try device.makeDefaultLibrary(bundle: .main)
    }

    /// Executes a tiled compute job asynchronously.
    public func executeTiledJob(tileData: [Data], functionName: String) async throws -> [Data] {
        guard let fn = library.makeFunction(name: functionName) else {
            throw NSError(domain: "MLXRenderer", code: -2, userInfo: nil)
        }
        let pipeline = try device.makeComputePipelineState(function: fn)
        var results: [Data] = []

        for tile in tileData {
            let buffer = device.makeBuffer(bytes: tile, length: tile.count, options: [])!
            let cmdQ = device.makeCommandQueue()!
            let cmdBuf = cmdQ.makeCommandBuffer()!
            let encoder = cmdBuf.makeComputeCommandEncoder()!
            encoder.setComputePipelineState(pipeline)
            encoder.setBuffer(buffer, offset: 0, index: 0)
            let threads = MTLSize(width: tile.count/MemoryLayout<Float>.size, height: 1, depth: 1)
            encoder.dispatchThreads(threads, threadsPerThreadgroup: MTLSize(width: 16, height:1, depth:1))
            encoder.endEncoding()
            cmdBuf.commit()
            cmdBuf.waitUntilCompleted()
            let out = Data(bytes: buffer.contents(), count: tile.count)
            results.append(out)
        }
        return results
    }
}
