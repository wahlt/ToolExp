//
//  ArchEngDescriptor.swift
//  EngineKit
//
//  Specification:
//  • Describes engine actor capabilities and versions.
//  • Used for discovery and compatibility checks.
//
//  Discussion:
//  When orchestrating multi-agent workflows, knowing each
//  actor’s supported intents and version aids coordination.
//
//  Rationale:
//  • Static descriptor avoids hardcoding strings in multiple places.
//  • Facilitates dynamic loading of new actors/plugins.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct ArchEngDescriptor {
    public let name: String
    public let version: String
    public let supportedIntents: [String]

    /// Default descriptor for ArchEngActor.
    public static var `default`: ArchEngDescriptor {
        ArchEngDescriptor(
            name: "ArchEngActor",
            version: "1.0.0",
            supportedIntents: ["physics", "data", "render"]
        )
    }
}
