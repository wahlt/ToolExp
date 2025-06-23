//
//  StageManifest.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  StageManifest.swift
//  StageKit
//
//  Specification:
//  • Manifest of all SuperStages and their configs.
//  • Reads/writes JSON to bundle or remote endpoint.
//
//  Discussion:
//  StageManifest drives the dropdown in ToolDev and default loading
//  in ToolExp, mapping stage IDs to their StageConfig.
//
//  Rationale:
//  • Central registry for dynamic stage discovery.
//  • Codable for easy bundling or over-the-air updates.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct StageManifest: Codable {
    public var configs:      [String: StageConfig]
    public var defaultStage: String
