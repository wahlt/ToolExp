//
//  ComputeFallback.swift
//  EngineKit
//
//  CPU‐only fallback implementations for physics integrators and
//  other tensorized operations when GPU/NPU backend is unavailable.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import simd

public struct ComputeFallback {
    /// Euler integrates positions by velocities over Δt.
    /// - Parameters:
    ///   - positions: Array of initial positions.
    ///   - velocities: Array of velocities.
    ///   - dt: Time step.
    /// - Returns: Updated positions.
    public static func integratePositions(
        positions: [SIMD3<Float>],
        velocities: [SIMD3<Float>],
        dt: Float
    ) -> [SIMD3<Float>] {
        precondition(positions.count == velocities.count,
                     "Positions & velocities length mismatch")
        return zip(positions, velocities).map { (p, v) in
            p + v * dt
        }
    }
}
