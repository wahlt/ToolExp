//
//  FysEngActor.swift
//  EngineKit
//
//  Actor façade over the tensor-native FysEngine core.
//  Provides a single async entry point:
//    `simulate(_:)`—which will run on GPU if available,
//    otherwise fall back to CPU Euler integration.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit
import simd

public actor FysEngActor {
    private let gpuEngine: FysEngine?

    /// - Parameter gpuEngine: Optional tensor-native engine. If `nil`, always uses CPU fallback.
    public init(gpuEngine: FysEngine? = FysEngine.default) {
        self.gpuEngine = gpuEngine
    }

    /// Simulate one step of the world.
    ///
    /// Tries GPU path first; if that fails (or no engine provided),
    /// falls back to simple CPU Euler integration with tuned constants.
    ///
    /// - Parameter rep: Input `RepStruct` whose cells must each have
    ///   `PositionTrait` and `VelocityTrait`.
    /// - Returns: New `RepStruct` with updated positions & velocities.
    public func simulate(_ rep: RepStruct) async throws -> RepStruct {
        // 1) GPU path
        if let engine = gpuEngine {
            do {
                // Convert Rep→tensor, step simulation, then tensor→Rep
                let state = try PhysEngAdapter.tensorFromRep(rep)
                let nextState = try engine.stepSimulation(
                    bodies: state,
                    constraints: MLXArray(zeros: [0, 0]),
                    deltaTime: 1/60
                )
                var result = rep
                try PhysEngAdapter.repFromTensor(nextState, rep: &result)
                return result
            } catch {
                // GPU path failed—fall through to CPU fallback
                print("FysEngActor: GPU simulation failed, falling back: \(error)")
            }
        }

        // 2) CPU fallback
        var result = rep
        let cells = rep.nodes
        // Gather positions & velocities (SIMD2<Float> or SIMD3<Float> as your world uses)
        let positions: [SIMD2<Float>] = cells.map {
            ($0.traits.first { $0 is PositionTrait } as? PositionTrait)?.position ?? .zero
        }
        let velocities: [SIMD2<Float>] = cells.map {
            ($0.traits.first { $0 is VelocityTrait } as? VelocityTrait)?.velocity ?? .zero
        }

        // Compute forces via your tuned formula:
        //    f = A·r⁻³ + B·r⁻² + C·Δv
        let forces = FysEngActor.computeForces(
            positions: positions,
            velocities: velocities,
            A: 1.0, B: 0.5, C: 0.1
        )

        // Integrate (Euler) with dt = 1/60
        let dt: Float = 1/60
        for i in 0..<cells.count {
            let cell = cells[i]
            let a = forces[i]
            let newV = velocities[i] + a * dt
            let newP = positions[i] + newV * dt

            // Remove old traits, add new ones
            result.nodes[i].traits.removeAll { $0 is PositionTrait || $0 is VelocityTrait }
            result.addTrait(PositionTrait(position: newP), to: result.nodes[i])
            result.addTrait(VelocityTrait(velocity: newV), to: result.nodes[i])
        }
        return result
    }

    // MARK: — CPU Force Calculator

    /// Brute-force N² pairwise force sums:
    ///    A·(r/r³) + B·(r/r²) + C·(dv)
    private static func computeForces(
        positions: [SIMD2<Float>],
        velocities: [SIMD2<Float>],
        A: Float, B: Float, C: Float
    ) -> [SIMD2<Float>] {
        let n = positions.count
        var forces = [SIMD2<Float>](repeating: .zero, count: n)
        for i in 0..<n {
            var fi: SIMD2<Float> = .zero
            for j in 0..<n where j != i {
                let delta = positions[j] - positions[i]
                let dist2 = max(dot(delta, delta), 1e-6)
                let r = sqrt(dist2)
                // direction
                let dir = delta / r
                // components
                fi += A * dir / (dist2 * r)         // A·r⁻³
                fi += B * dir / dist2               // B·r⁻²
                fi += C * (velocities[j] - velocities[i])
            }
            forces[i] = fi
        }
        return forces
    }
}
