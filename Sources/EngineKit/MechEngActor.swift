//
//  MechEngActor.swift
//  EngineKit
//
//  Coordinates mechanical-engine updates: physics + rule-based traits.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public final class MechEngActor {
    private let fysActor: FysEngActor

    public init(fysActor: FysEngActor) {
        self.fysActor = fysActor
    }

    /// Performs a full mechanics update cycle.
    /// - Parameter dt: Time step.
    public func update(deltaTime dt: Float) throws {
        // 1) Tensorized physics step
        try fysActor.simulateStep(dt: dt)
        // 2) Here you could apply additional mechanical rules or trait updates
    }
}
