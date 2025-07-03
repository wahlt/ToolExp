//
//  PhysEngAdapter.swift
//  EngineKit
//
//  Translates between RepStruct nodes/traits and
//  PhysicsKit’s MLXArray state vectors.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import RepKit
import MLX

public struct PhysEngAdapter {
    /// Builds a state tensor from `RepStruct` nodes carrying `PositionTrait` and `VelocityTrait`.
    /// - Returns MLXArray of shape `[N,6]` where each row is [x,y,z,vx,vy,vz].
    public static func tensorFromRep(_ rep: RepStruct) throws -> MLXArray {
        var flat: [Float] = []
        for node in rep.nodes {
            let pos: SIMD3<Float> = node.traits
                .compactMap { ($0 as? PositionTrait)?.position }
                .first ?? .zero
            let vel: SIMD3<Float> = node.traits
                .compactMap { ($0 as? VelocityTrait)?.velocity }
                .first ?? .zero
            flat += [pos.x, pos.y, pos.z, vel.x, vel.y, vel.z]
        }
        let n = rep.nodes.count
        return try MLXArray.make(values: flat, shape: [n, 6], precision: .fp32)
    }

    /// Applies a `[N,6]` state tensor back onto `RepStruct` nodes’ PositionTrait.
    public static func repFromTensor(_ tensor: MLXArray, rep: inout RepStruct) throws {
        let scalars = tensor.scalars
        let n = rep.nodes.count
        guard scalars.count >= n * 6 else {
            fatalError("PhysEngAdapter: tensor size mismatch")
        }
        for i in 0..<n {
            let base = i * 6
            let p = SIMD3<Float>(scalars[base],
                                 scalars[base+1],
                                 scalars[base+2])
            rep.nodes[i].traits.removeAll { $0 is PositionTrait }
            rep.addTrait(PositionTrait(position: p), to: rep.nodes[i])
        }
    }
}
