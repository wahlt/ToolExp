//
//  Relate.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Relate.swift
// DataServ — Relationship‐structure operations.
//
// Utilities to derive higher‐order relationships between cells.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Find all cells that both `a` and `b` connect to (common neighbors).
    ///
    /// - Returns: Array of `Cell` that are targets of both `a`’s and `b`’s ports.
    func commonNeighbors(of a: RepID, and b: RepID) -> [Cell] {
        let neighA = Set(cells[a]?.ports.values ?? [])
        let neighB = Set(cells[b]?.ports.values ?? [])
        let intersection = neighA.intersection(neighB)
        return intersection.compactMap { cells[$0] }
    }
}
