//
//  FysEngActor.swift
//  EngineKit
//
//  Specification:
//  • Physics actor that de-tangles Rep node graphs via spring-damper + repulsion.
//  • Updates node positions and velocities each simulation step.
//
//  Discussion:
//  To resolve overlapping nodes (“tangles”), each edge applies Hooke’s law
//  and a damping force; non-linked nodes repel via inverse-square law.
//
//  Rationale:
//  • Spring-damper captures elastic connections; 1/r² handles collisions.
//  • Using an actor ensures thread safety across concurrent ArchEng calls.
//
//  Dependencies: RepKit, simd
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit
import simd

public actor FysEngActor {
    public static let shared = FysEngActor()
    private init() {}

    // Spring constant (k), damping coefficient (c), softening epsilon (ε)
    private let k: Float = 2.0, c: Float = 0.5, ε: Float = 0.01

    /// Simulates one time step for the given Rep nodes & edges.
    public func simulate(nodes: inout [RepNode], edges: [(Int, Int)], delta: Float) {
        var forces = Array(repeating: SIMD3<Float>(repeating: 0), count: nodes.count)

        // Spring-damper forces on linked nodes.
        for (i, j) in edges {
            let xi = nodes[i].position, xj = nodes[j].position
            let vi = nodes[i].velocity, vj = nodes[j].velocity
            let dvec = xi - xj
            // softened squared-distance: r² + ε
            let d2 = max(dot(dvec, dvec), ε)
            let d  = sqrt(d2)
            let dir = d > 0 ? dvec / d : SIMD3<Float>(1,0,0)
            // Hooke’s law: -k*(d)
            let Fspring = -k * d * dir
            // Damping: -c*(vi - vj)
            let Fdamp = -c * (vi - vj)
            forces[i] += Fspring + Fdamp
            forces[j] -= Fspring + Fdamp
        }

        // Repulsion for all pairs.
        for i in 0..<nodes.count {
            for j in (i+1)..<nodes.count {
                let disp = nodes[i].position - nodes[j].position
                let dist2 = max(dot(disp, disp), ε)
                let dist = sqrt(dist2)
                // Repulsion ∝ 1/r³
                let Frep = k / (dist2 * dist)
                let dir = dist > 0 ? disp / dist : SIMD3<Float>(1,0,0)
                forces[i] += Frep * dir
                forces[j] -= Frep * dir
            }
        }

        // Integrate and apply.
        for idx in nodes.indices {
            var node = nodes[idx]
            let accel = forces[idx]  // mass=1 assumed
            node.velocity += accel * delta
            node.position += node.velocity * delta
            // Apply global damping
            node.velocity *= 0.99
            nodes[idx] = node
        }
    }
}
