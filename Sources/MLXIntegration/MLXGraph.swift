//
//  MLXGraph.swift
//  MLXIntegration
//
//  Convenience wrapper around MPSGraph for quick add/run usage.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import MetalPerformanceShadersGraph

public final class MLXGraph {
    private let graph: MPSGraph

    public init() {
        self.graph = MPSGraph()
    }

    /// Runs the graph with the given feeds and returns the tensor outputs.
    /// - Parameters:
    ///   - feeds: Mapping from placeholder tensors to their data.
    ///   - targetTensors: List of tensors to return.
    /// - Returns: Mapping tensor→TensorData.
    public func run(
        feeds: [MPSGraphTensor: MPSGraphTensorData],
        targetTensors: [MPSGraphTensor]
    ) throws -> [MPSGraphTensor: MPSGraphTensorData] {
        let device = MPSGraphDevice.default()!
        let executable = try graph.compile(
            with: Array(feeds.keys),
            targetTensors: targetTensors,
            targetOperations: nil,
            device: device
        )
        let cmdBuf = MLXCommandQueue.shared.queue.makeCommandBuffer()!
        let results = try executable.encode(
            to: cmdBuf,
            feeds: feeds,
            targetTensors: targetTensors,
            targetOperations: nil
        )
        cmdBuf.commit()
        cmdBuf.waitUntilCompleted()
        return results
    }
}
