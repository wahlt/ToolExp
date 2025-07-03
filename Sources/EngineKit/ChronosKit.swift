//
//  ChronosKit.swift
//  EngineKit
//
//  Deprecated in favor of PhysicsKit.stepSimulation(deltaTime:).
//
//  Stub remains to avoid build errors if still imported.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

@available(*, deprecated,
    message: "Use PhysicsKit.stepSimulation(deltaTime:). ChronosKit will be removed in v1.5."
)
public struct ChronosKit {
    @available(*, deprecated,
        message: "ChronosKit stub. No-op."
    )
    public static func schedule(deltaTime: Float, _ block: @escaping () -> Void) {
        // No-op stub
    }
}
