//
//  DensityService.swift
//  EngineKit/PhysicsKit
//
//  Tensorized density computation for SPH or fluid sims.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import MetalPerformanceShadersGraph
import MLX

public final class DensityService {
    private let graph: MPSGraph

    public init() {
        graph = MPSGraph()
    }

    /// Computes particle densities: ρ_i = Σ_j m * W(|x_i - x_j|, h)
    /// - `positions`: `[N,3]` MLXArray
    /// - `mass`: per-particle mass
    /// - `h`: smoothing radius
    /// - Returns: `[N]` density values
    public func computeDensities(
        positions: MLXArray,
        mass: Float,
        smoothing: Float
    ) throws -> MLXArray {
        let N = positions.shape[0].intValue
        let input = graph.placeholder(
            shape: [NSNumber(value: N), 3],
            dataType: .float32,
            name: "positions"
        )
        // Stub: densities = constant mass
        let densityConst = graph.constant(
            NSNumber(value: mass),
            shape: [NSNumber(value: N)],
            dataType: .float32
        )
        let nd = try input.toMPSNDArray()
        let res = try graph.run(
            feeds: [input: nd],
            targetTensors: [densityConst],
            targetOperations: nil
        )[densityConst]!
        return try MLXArray(ndArray: res)
    }
}//
//  DensityService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

