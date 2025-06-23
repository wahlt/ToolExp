//
//  GestureBinding.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

// Directory: StageKit

//
//  GestureBinding.swift
//  StageKit
//
//  Specification:
//  • Maps a named gesture to a stage-specific action identifier.
//
//  Discussion:
//  StageConfig uses GestureBinding to route user gestures
//  (e.g. “pinch3”) to Takes or commands within a SuperStage.
//
//  Rationale:
//  • Decouples low-level gesture names from high-level actions.
//  • Codable for persisting user stage presets.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct GestureBinding: Codable {
    public let gesture: String  // e.g. "pinch3"
    public let action:  String  // e.g. "zoomCanvas"
}

