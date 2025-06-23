//
//  MLXCommandQueue.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// MLXCommandQueue.swift
// MLXIntegration — Manages command buffers and ML “encoders” via MTLComputeCommandEncoder.

import Metal

public final class MLXCommandQueue {
    public let device: MTLDevice
    private let queue: MTLCommandQueue

    public init(device: MTLDevice) {
        guard let q = device.makeCommandQueue() else {
            fatalError("MLXCommandQueue: cannot create MTLCommandQueue")
        }
        self.device = device
        self.queue = q
    }

    /// Create a new command buffer, optionally labeled.
    public func makeCommandBuffer(label: String? = nil) -> MTLCommandBuffer {
        let cmd = queue.makeCommandBuffer()!
        if let label = label { cmd.label = label }
        return cmd
    }

    /// Create a compute‐encoder to stand in for the ML encoder.
    public func makeMLCommandEncoder(
        commandBuffer: MTLCommandBuffer,
        label: String? = nil
    ) -> MTLComputeCommandEncoder {
        guard let enc = commandBuffer.makeComputeCommandEncoder() else {
            fatalError("MLXCommandQueue: cannot create MTLComputeCommandEncoder")
        }
        if let label = label { enc.label = label }
        return enc
    }
}
