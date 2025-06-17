//
//  ECSArchetype.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ECSArchetype.swift
// RepKit — Entity‐Component‐System (ECS) archetype grouping.
//
// Stores cells sharing an identical set of “components” (traits)
// to allow tight data‐parallel iteration and faster lookups.
//
// Usage:
//   let arch = Archetype(signature: Set(["Physics","Renderable"]))
//   arch.add(cell)  // only if cell’s signature matches
//

import Foundation

/// Represents a contiguous group of cells that share the same component (trait) set.
public struct Archetype {
    /// The set of trait names defining this archetype.
    public let signature: Set<String>
    /// The cell IDs belonging to this archetype.
    public private(set) var cellIDs: [RepID]

    /// Create an empty archetype with the given signature.
    public init(signature: Set<String>, cellIDs: [RepID] = []) {
        self.signature = signature
        self.cellIDs = cellIDs
    }

    /// Add a cell (if its traits match `signature`).
    ///
    /// - Parameter cell: the cell to add.
    /// - Note: A real implementation would check `cell.traits.keys == signature`.
    public mutating func add(_ cell: Cell) {
        // TODO: verify cell’s trait names exactly match `signature`.
        cellIDs.append(cell.id)
    }

    /// Remove a cell by ID.
    ///
    /// - Parameter cellID: the ID to remove.
    public mutating func remove(cellID: RepID) {
        cellIDs.removeAll { $0 == cellID }
    }
}
