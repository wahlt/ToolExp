// File: Sources/MLXIntegration/MLXRenderer.swift
//  MLXIntegration
//
//  Specification:
//  • Actor-based GPU compute pipeline manager for ML inference on Metal devices.
//
//  Discussion:
//  MLXRenderer asynchronously compiles compute shaders into pipeline states,
//  then encodes and dispatches command buffers for each data tile,
//  returning the processed results as Data buffers without blocking the main thread.
//
//  Rationale:
//  • Async/await keeps GPU work off the main thread safely.
//  • Actor isolation ensures thread-safe pipeline reuse and state management.
//  • Resource-based shader loading integrates with SwiftPM’s resource model.
//
//  TODO:
//  • Extend binding logic to include actual texture/buffer setup per MLXTensor.
//  • Add error categorization and logging via FPKit for GPU failures.
//  • Expose dispatch parameters for performance tuning in ToolTune SuperStage.
//
//  Dependencies: Foundation, Metal
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//
import Foundation
import Metal

public actor MLXRenderer {
    private let device: MTLDevice
    private let pipeline: MTLComputePipelineState

    /// Initializes the compute pipeline state for a given shader function.
    /// - Parameter functionName: Name of the compute function in the default Metal library.
    public init(functionName: String) async throws {
        // Acquire the system GPU device
        guard let dev = MTLCreateSystemDefaultDevice() else {
            throw NSError(domain: "MLXRenderer", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "No Metal device available"
            ])
        }
        self.device = dev

        // Load the default library and retrieve the compute function
        let library = device.makeDefaultLibrary()
            ?? { fatalError("Default Metal library not found") }()
        guard let fn = library.makeFunction(name: functionName) else {
            throw NSError(domain: "MLXRenderer", code: -2, userInfo: [
                NSLocalizedDescriptionKey: "Function \(functionName) not found"
            ])
        }

        // Asynchronously compile the compute pipeline for efficiency
        self.pipeline = try await device.makeComputePipelineState(function: fn)
    }

    /// Executes inference on each tile of input Data.
    /// - Parameter tileData: Array of raw data buffers representing input tiles.
    /// - Returns: Array of processed Data results in the same order.
    public func execute(tileData: [Data]) async throws -> [Data] {
        var results: [Data] = []

        for tile in tileData {
            // Create a fresh command buffer for isolation
            let cmdQ   = device.makeCommandQueue()!
            let cmdBuf = cmdQ.makeCommandBuffer()!
            let encoder = cmdBuf.makeComputeCommandEncoder()!
            encoder.setComputePipelineState(pipeline)

            // TODO: bind tile bytes/textures to encoder here

            encoder.endEncoding()
            cmdBuf.commit()
            // Await GPU completion without blocking the actor queue
            await cmdBuf.completed()

            // Copy back raw results; using withUnsafeBytes for safe buffer access
            let out = tile.withUnsafeBytes { ptr in
                Data(bytes: ptr.baseAddress!, count: tile.count)
            }
            results.append(out)
        }

        return results
    }
}
