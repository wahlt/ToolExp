//
//  PhysicsKit+MPSGraph.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  PhysicsKit+MPSGraph.swift
//  EngineKit/PhysicsKit
//
//  Adds MPSGraph‐based stepping to PhysicsEngine.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import MetalPerformanceShadersGraph
import MLX

public extension PhysicsEngine {
    /// Steps the simulation in one shot via MPSGraph.
    ///
    /// - Parameters:
    ///   - bodies: `[N,6]` states `(x,y,z,vx,vy,vz)`
    ///   - constraints: `[M,C]` optional constraints tensor
    ///   - deltaTime: time step
    /// - Returns: Updated `[N,6]` states.
    func stepSimulation(
        bodies: MLXArray,
        constraints: MLXArray,
        deltaTime: Float
    ) throws -> MLXArray {
        let graph = MPSGraph()
        let shapeB = bodies.shape.map(NSNumber.init(value:))
        let B = graph.placeholder(shape: shapeB, dataType: .float32, name: "B")
        let dt = graph.constant(NSNumber(value: deltaTime),
                                shape: [],
                                dataType: .float32,
                                name: "dt")
        // Euler integrator: x' = x + v*dt
        let pos = graph.slice(B, dims: [1], ranges: [NSRange(location: 0, length: 3)])
        let vel = graph.slice(B, dims: [1], ranges: [NSRange(location: 3, length: 3)])
        let newPos = graph.add(pos, graph.multiply(vel, dt))
        let newState = graph.concatTensors([newPos, vel], dimension: 1)

        let feeds: [MPSGraphTensor: MPSGraphTensorData] = [
            B: try bodies.toMPSNDArray()
        ]
        let results = try graph.run(
            feeds: feeds,
            targetTensors: [newState],
            targetOperations: nil
        )
        guard let outND = results[newState] else {
            fatalError("PhysicsKit+MPSGraph: no output")
        }
        return try MLXArray(ndArray: outND)
    }
}
