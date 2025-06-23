// File: Sources/StageKit/StageConfig.swift
//  StageKit
//
//  Specification:
//  • Configuration structure for a single SuperStage.
//  • Holds overlays, gesture bindings, and “takes” loadouts.
//
//  Discussion:
//  ToolDev, ToolExp, ToolTensor, etc. are all represented as StageConfig
//  entries in the central StageManifest for dynamic UI generation.
//
//  Rationale:
//  • Isolates per-stage metadata into a single codable struct.
//  • Sendable conformance allows stage configs to flow through actor contexts safely.
//
//  TODO:
//  • Validate that `overlays` and `takeLoadouts` refer to existing resource names.
//  • Support theme overrides per stage.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct StageConfig: Codable, Sendable {
    /// Human‐readable name of the stage
    public let name: String
    /// Names of HUD overlays to enable by default
    public var overlays: [String]
    /// Gesture‐to‐action bindings
    public var gestureBindings: [String]
    /// Preconfigured UI “takes” to load on entry
    public var takeLoadouts: [String]

    public init(
        name: String,
        overlays: [String] = [],
        gestureBindings: [String] = [],
        takeLoadouts: [String] = []
    ) {
        self.name = name
        self.overlays = overlays
        self.gestureBindings = gestureBindings
        self.takeLoadouts = takeLoadouts
    }
}
