// File: Sources/RepKit/RepIntegrityChecker.swift
//  RepKit
//
//  Specification:
//  • Verifies that the directed graph defined by cell.ports has no cycles.
//  • Throws `RepIntegrityError.cycleDetected` on first detected loop.
//
//  Discussion:
//  We build an `idIndex` to map cell IDs → array indices, then
//  recursively traverse the graph, tracking a DFS stack for cycle detection.
//
//  Rationale:
//  • Protects downstream algorithms (layout, physics) from infinite loops.
//  • Provides fast bail‐out on malformed rep graphs.
//
//  TODO:
//  • Report path of the detected cycle for debugging.
//  • Integrate with ToolProof to mark invalid reps visually.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Errors that can occur during integrity checking.
public enum RepIntegrityError: Error {
    /// A cycle was found in the directed graph.
    case cycleDetected
}

/// Performs a DFS‐based cycle check on a `RepStruct`.
public struct RepIntegrityChecker {
    /// Check for cycles in the rep; throws on the first found.
    /// - Parameter rep: the rep structure to analyze.
    public static func check(_ rep: RepStruct) throws {
        // Map each cell’s UUID to its array index
        let idIndex = Dictionary(
            uniqueKeysWithValues: rep.cells.enumerated().map { ($1.id, $0) }
        )

        var visited = Set<UUID>()
        var stack   = Set<UUID>()

        func dfs(_ id: UUID) throws {
            // If this ID is already on the current DFS stack → cycle
            if stack.contains(id) {
                throw RepIntegrityError.cycleDetected
            }
            // If we’ve fully visited this node before, skip
            if visited.contains(id) {
                return
            }
            visited.insert(id)
            stack.insert(id)

            // Lookup index and cell
            guard let idx = idIndex[id] else {
                stack.remove(id)
                return
            }
            let cell = rep.cells[idx]

            // Recurse into each outgoing port
            for targetID in cell.ports.values {
                try dfs(targetID)
            }

            // Pop this ID off the DFS stack
            stack.remove(id)
        }

        // Kick off DFS from each cell
        for cell in rep.cells {
            try dfs(cell.id)
        }
    }
}
