//
//  FysEngine.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/23/25.
//

//
//  FysEngine.swift
//  EngineKit
//
//  Specification:
//  • Computes pairwise fantasy-physics forces for rep-element detangling.
//  • Softens singularities by adding ε to the distance.
//
//  Discussion:
//  When GPU acceleration isn’t available, we fall back to this CPU loop.
//  It applies attraction (∝ r⁻²), repulsion (∝ r⁻³), and viscous drag (∝ v).
//
//  Rationale:
//  • Keeps UI responsive on devices without MLX pipelines.
//  • Softening ε=0.01 prevents blow-up at small separations.
//  • Parameters A, B, C exposed for in-app performance tuning.
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import simd

public struct FysEngine {
    /// Softening constant to avoid singularity.
    public static let epsilon: Float = 0.01

    /// Compute the net force on each element given positions and velocities.
    ///
    /// - Parameters:
    ///   - positions: array of 2D positions (x,y) of each rep element.
    ///   - velocities: array of 2D velocities of each rep element.
    ///   - A: attraction strength coefficient (>0).
    ///   - B: repulsion strength coefficient (>0).
    ///   - C: drag coefficient (>=0).
    /// - Returns: updated array of forces to apply.
    public static func computeForces(
        positions: [SIMD2<Float>],
        velocities: [SIMD2<Float>],
        A: Float,
        B: Float,
        C: Float
    ) -> [SIMD2<Float>] {
        let n = positions.count
        var forces = Array(repeating: SIMD2<Float>(.zero), count: n)

        for i in 0..<n {
            var net = SIMD2<Float>(.zero)
            let pi = positions[i]
            let vi = velocities[i]

            for j in 0..<n where j != i {
                let pj = positions[j]
                let vj = velocities[j]

                var delta = pj - pi
                let r = length(delta)
                // Softened distance
                let rε = r + epsilon

                // Attraction ∝ 1/rε², Repulsion ∝ 1/rε³
                let attr   = A / (rε * rε)
                let repl   = B / (rε * rε * rε)
                // Drag ∝ relative velocity dot normalized delta
                let relV   = vj - vi
                let drag   = C * dot(relV, delta / rε)

                // Total scalar magnitude along delta vector
                let mag = attr - repl - drag

                // Add vector contribution
                net += mag * (delta / rε)
            }
            forces[i] = net
        }

        return forces
    }
}
