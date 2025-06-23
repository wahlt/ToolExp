//
//  StageConfig.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  StageConfig.swift
//  StageKit
//
//  Specification:
//  • User-visible config for a SuperStage.
//  • Defines overlays, gesture bindings, and take loadouts.
//
//  Discussion:
//  ToolDev presents StageConfig for customization of each
//  SuperStage’s UI and behavior at runtime.
//
//  Rationale:
//  • Codable for JSON-backed presets.
//  • Direct mapping to StageManifest for discovery.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct StageConfig: Codable {
    public let name:            String
    public var overlays:       [String]
    public var gestureBindings: [GestureBinding]
    public var takeLoadouts:   [String]
}
