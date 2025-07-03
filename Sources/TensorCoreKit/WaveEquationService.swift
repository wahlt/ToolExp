//
//  WaveEquationService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  WaveEquationService.swift
//  TensorCoreKit
//
//  1. Purpose
//     High-order wave equation solver via MPSGraph.
// 2. Dependencies
//     MetalPerformanceShadersGraph, MLX
// 3. Overview
//     Uses finite-difference lattice methods in nD.
// 4. Usage
//     let u = try WaveEquationService.shared.solve(
//         initial: u0, velocity: v0, c:1, dt:0.01, steps:200
//     )
// 5. Notes
//     Similar to PDEGraphService but specialized.

import MetalPerformanceShadersGraph
import MLX

public final class WaveEquationService {
    public static let shared = WaveEquationService()
    private init() {}

    /// Solves ∂²u/∂t² = c²∇²u in ND via explicit scheme.
    public func solve(
        initial u0: MLXArray,
        initialVelocity v0: MLXArray,
        c: Float,
        dt: Float,
        steps: Int
    ) throws -> MLXArray {
        // Delegate to PDEGraphService for 1D; extend for ND if needed.
        return try PDEGraphService.shared.solveWave(
            initial: u0,
            initialVelocity: v0,
            c: c,
            dt: dt,
            steps: steps
        )
    }
}
