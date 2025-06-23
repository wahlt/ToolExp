// File: Sources/MLXIntegration/MLXCommandQueue.swift
//
//  MLXCommandQueue.swift
//  MLXIntegration
//
//  Specification:
//  • Manages Metal command queues and compute encoders for ML pipelines.
//
//  Discussion:
//  Centralizes creation of MTLCommandBuffer and MTLComputeCommandEncoder
//  with optional labeling for GPU debugging and profiling.
//
//  Rationale:
//  • Prevents duplication of queue/encoder setup across modules.
//  • Labels improve GPU frame capture and debugging in Xcode.
//
//  Dependencies: Metal
//  Created by Thomas Wahl on 06/17/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Metal

public final class MLXCommandQueue {
    public let device: MTLDevice
    private let queue: MTLCommandQueue

    public init(device: MTLDevice) {
        guard let q = device.makeCommandQueue() else {
            fatalError("MLXCommandQueue: cannot create MTLCommandQueue")
        }
        self.device = device
        self.queue  = q
    }

    /// Creates a new command buffer, with an optional label.
    public func makeCommandBuffer(label: String? = nil) -> MTLCommandBuffer {
        let cmd = queue.makeCommandBuffer()!
        if let label = label {
            cmd.label = label
        }
        return cmd
    }

    /// Creates a compute encoder for ML tasks on the given buffer.
    public func makeMLCommandEncoder(
        commandBuffer: MTLCommandBuffer,
        label: String? = nil
    ) -> MTLComputeCommandEncoder {
        guard let enc = commandBuffer.makeComputeCommandEncoder() else {
            fatalError("MLXCommandQueue: cannot create MTLComputeCommandEncoder")
        }
        if let label = label {
            enc.label = label
        }
        return enc
    }
}
