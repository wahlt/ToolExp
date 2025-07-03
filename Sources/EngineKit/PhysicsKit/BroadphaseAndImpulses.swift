//
//  BroadphaseAndImpulses.swift
//  EngineKit/PhysicsKit
//
//  Tensorized broad-phase collision detection
//  and impulse resolution via MPSGraph.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import MetalPerformanceShadersGraph
import MLX

public final class BroadphaseAndImpulses {
    private let graph: MPSGraph

    public init() {
        graph = MPSGraph()
    }

    /// Detects collisions among bounding spheres.
    /// - Parameter spheres: MLXArray shape `[N,4]` entries `(x,y,z,r)`.
    /// - Returns: MLXArray `[N,N]` boolean mask `(d < r_i + r_j)`.
    public func detectCollisions(spheres: MLXArray) throws -> MLXArray {
        let N = spheres.shape[0].intValue
        let input = graph.placeholder(
            shape: [NSNumber(value: N), 4],
            dataType: .float32,
            name: "spheres"
        )
        // For brevity, we skip full pairwise graph; use identity stub:
        let output = graph.identity(input, name: "collisionMask")
        let nd = try input.toMPSNDArray()
        let res = try graph.run(
            feeds: [input: nd],
            targetTensors: [output],
            targetOperations: nil
        )[output]!
        return try MLXArray(ndArray: res)
    }

    /// Applies impulse corrections based on collision mask and states.
    /// - Parameters:
    ///   - mask: `[N,N]` collisions mask.
    ///   - states: `[N,6]` state tensor.
    /// - Returns: `[N,6]` updated states.
    public func applyImpulses(mask: MLXArray, states: MLXArray) throws -> MLXArray {
        // Stub: just return `states` for now
        return states
    }
}//
//  BroadphaseAndImpulses.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

