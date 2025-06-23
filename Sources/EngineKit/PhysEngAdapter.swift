//
//  PhysEngAdapter.swift
//  EngineKit
//
//  Specification:
//  • Adapter bridging generic physics calls to MechEngActor.
//  • Normalizes payloads for impulse or full-step operations.
//
//  Discussion:
//  Higher-level code emits varied payloads; adapter standardizes them.
//
//  Rationale:
//  • Keeps ArchEngActor decoupled from physics API details.
//  • Provides future hook for GPU-driven physics engines.
//
//  Dependencies: simd, MechEngActor
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import simd

public enum PhysEngAdapter {
    /// Applies a discrete impulse to a single node.
    public static func applyImpulse(to repID: UUID, nodeIndex: Int, force: SIMD3<Float>) async {
        let payload = ["rep": repID, "index": nodeIndex, "force": force] as [String: Any]
        try? await MechEngActor.shared.apply(payload)
    }

    /// Runs a full physics simulation step.
    public static func step(repID: UUID) async {
        try? await MechEngActor.shared.apply(repID)
    }
}
