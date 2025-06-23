// File: Sources/StageKit/StageManifest.swift
//  StageKit
//
//  Specification:
//  • Aggregates all StageConfig entries with a default active stage.
//
//  Discussion:
//  The manifest drives the stage‐selection UI and initial load on app launch.
//  It can be overridden by JSON for remote configuration if needed.
//
//  Rationale:
//  • Centralizes stage metadata in one Codable, Sendable type.
//  • Enables dynamic addition/removal of SuperStages without code changes.
//
//  TODO:
//  • Implement validation that `defaultStage` exists in `configs`.
//  • Support runtime updates to the manifest from a server.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct StageManifest: Codable, Sendable {
    /// Mapping of stage names to their configs
    public var configs: [String: StageConfig]
    /// Key of the default stage to load on startup
    public var defaultStage: String

    public init(configs: [String: StageConfig], defaultStage: String) {
        self.configs = configs
        self.defaultStage = defaultStage
    }
}
