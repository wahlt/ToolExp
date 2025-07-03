//
//  MLXCommandQueue.swift
//  MLXIntegration
//
//  Singleton command‐queue provider for Metal and MLX workloads.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Metal

public final class MLXCommandQueue {
    public let device: MTLDevice
    public let queue: MTLCommandQueue

    /// Shared default queue.
    public static let shared: MLXCommandQueue = {
        try! MLXCommandQueue()
    }()

    /// Initializes a new command queue on the default system device.
    public init(device: MTLDevice? = MTLCreateSystemDefaultDevice()) throws {
        guard let dev = device else {
            throw MLXError.noMetalDevice
        }
        self.device = dev
        guard let q = dev.makeCommandQueue() else {
            throw MLXError.commandQueueCreationFailed
        }
        self.queue = q
    }

    public enum MLXError: Error {
        case noMetalDevice
        case commandQueueCreationFailed
    }
}
