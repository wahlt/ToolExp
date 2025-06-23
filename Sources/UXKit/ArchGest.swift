//
//  ArchGest.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ArchGest.swift
// UXKit — High-level orchestration of architecture gestures.
//
// Defines how multi-touch sequences map to Rep-graph operations.
//

import SwiftUI
import RepKit

/// A single gesture command for ArchEng.
public enum ArchCommand {
    case selectNode(RepID)
    case connectNodes(RepID, RepID)
    case createSubgraph([RepID])
}

/// Controller that takes raw gesture inputs and emits `ArchCommand`s.
public final class ArchGest {
    /// Interpret a sequence of touches & actions.
    /// - Returns: a list of proposed commands.
    public func interpret(
        touches: [CGPoint],
        gestureType: String,
        parameters: [String: Any]
    ) -> [ArchCommand] {
        // TODO: implement trait-moderated rules to form commands.
        return []
    }
}
