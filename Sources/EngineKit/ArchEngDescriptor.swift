//
//  ArchEngDescriptor.swift
//  EngineKit
//
//  Provides metadata about the ArchEng capabilities.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct ArchEngDescriptor {
    /// Human-readable engine name.
    public static let name = "Tensorized Architecture Engine"
    /// Semantic version of this engine.
    public static let version = "1.0.0"
    /// Engine features exposed.
    public static let features: [String] = [
        "validateProof",
        "suggestNextProofStep",
        "completeProof"
    ]
}
