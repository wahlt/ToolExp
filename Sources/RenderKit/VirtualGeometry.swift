//
//  VirtualGeometry.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// VirtualGeometry.swift
// RenderKit — GPU-accelerated mesh virtualization via Metal 4 compute/mesh shaders.
//
// This class takes a raw vertex + index buffer and produces a “virtualized” mesh,
// for infinite LOD or detail-on-demand. Uses Metal 4’s mesh pipeline and argument buffers.
//

import Metal
import MetalKit

/// High-level API for generating virtualized geometry on the GPU.
public struct VirtualGeometry {
    /// The GPU device.
    private let device: MTLDevice
    /// The mesh/compute pipeline state.
    private let pipelineState: MTLComputePipelineState

    /// Initialize with the default library’s `virtual_geometry_kernel` function.
    /// - Throws if the kernel can’t be found or pipeline creation fails.
    public init(device: MTLDevice) throws {
        self.device = device

        // 1. Load the default library shipped with the app.
        guard let library = device.makeDefaultLibrary() else {
            throw NSError(
                domain: "RenderKit",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Default Metal library missing"]
            )
        }

        // 2. Find our compute kernel entry point.
        guard let function = library.makeFunction(name: "virtual_geometry_kernel") else {
            throw NSError(
                domain: "RenderKit",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Function 'virtual_geometry_kernel' not found"]
            )
        }

        // 3. Create the compute pipeline state.
        pipelineState = try device.makeComputePipelineState(function: function)
    }

    /// Generate a new mesh given input buffers.
    ///
    /// - Parameters:
    ///   - vertexBuffer: GPU buffer of `float3` positions.
    ///   - indexBuffer:  GPU buffer of `uint` indices.
    ///   - commandQueue: MTLCommandQueue to schedule work.
    /// - Returns: Tuple `(outVertexBuffer, outIndexBuffer)` containing the virtualized mesh.
    /// - Throws: if command buffer or encoder creation fails.
    public func generate(
        vertexBuffer: MTLBuffer,
        indexBuffer: MTLBuffer,
        commandQueue: MTLCommandQueue
    ) throws -> (MTLBuffer, MTLBuffer) {
        // 1. Allocate output buffers (same length as inputs for now).
        let outVertexBuffer = device.makeBuffer(length: vertexBuffer.length, options: .storageModeShared)!
        let outIndexBuffer  = device.makeBuffer(length: indexBuffer.length, options: .storageModeShared)!

        // 2. Create a command buffer.
        guard let cmdBuf = commandQueue.makeCommandBuffer() else {
            throw NSError(domain: "RenderKit", code: 3, userInfo: nil)
        }

        // 3. Create a compute encoder.
        guard let encoder = cmdBuf.makeComputeCommandEncoder() else {
            throw NSError(domain: "RenderKit", code: 4, userInfo: nil)
        }

        // 4. Bind pipeline and buffers:
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setBuffer(indexBuffer,  offset: 0, index: 1)
        encoder.setBuffer(outVertexBuffer, offset: 0, index: 2)
        encoder.setBuffer(outIndexBuffer,  offset: 0, index: 3)

        // 5. Determine threadgroup sizes:
        let w = pipelineState.threadExecutionWidth
        let tg = MTLSize(width: w, height: 1, depth: 1)
        let gridSize = MTLSize(
            width: (vertexBuffer.length / MemoryLayout<SIMD3<Float>>.stride + w - 1) / w * w,
            height: 1,
            depth: 1
        )

        // 6. Dispatch the compute pass.
        encoder.dispatchThreads(gridSize, threadsPerThreadgroup: tg)

        // 7. Finish encoding, commit, and wait for completion.
        encoder.endEncoding()
        cmdBuf.commit()
        cmdBuf.waitUntilCompleted()

        // 8. Return the new buffers to the caller.
        return (outVertexBuffer, outIndexBuffer)
    }
}
