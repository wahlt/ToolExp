//
//  PhysEngAdapter.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// PhysEngAdapter.swift
// EngineKit — Unified adapter for multiple physics engines.
//
// Responsibilities:
//
//  1. Abstract over FysEngActor, MechEngActor, RealityKit, custom solvers.
//  2. Route simulation requests to the appropriate engine.
//  3. Provide fallback if primary engine unavailable.
//

import Foundation
import RepKit

public enum PhysicsEngineType {
    case mechanical
    case fantasy
    case realityKit
}

/// Adapter interface.
public final class PhysEngAdapter {
    private let mech: MechEngActor
    private let fys: FysEngActor

    public init(mechanical: MechEngActor = .init(), fantasy: FysEngActor = .init()) {
        self.mech = mechanical
        self.fys = fantasy
    }

    /// Simulate `rep` by `dt` on the chosen `engineType`.
    public func simulate(
        rep: RepStruct,
        dt: TimeInterval,
        using engineType: PhysicsEngineType
    ) -> RepStruct {
        switch engineType {
        case .mechanical:
            return mech.step(rep: rep, dt: dt)
        case .fantasy:
            return fys.simulate(rep: rep, dt: dt)
        case .realityKit:
            // TODO: integrate RealityKit simulation for physics bodies.
            return rep
        }
    }
}
