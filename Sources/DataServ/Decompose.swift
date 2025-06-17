//
//  Decompose.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Decompose.swift
// DataServ — Scene inventory & stroke lineage decomposition.
//
// Provides a way to split a large Rep graph into its connected
// subgraphs, so each can be edited, rendered, or processed in isolation.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Extract all connected subgraphs as independent `RepStruct`s.
    ///
    /// - Returns: An array of `RepStruct`, one per connected component
    ///   in the original graph.  Each new Rep has a fresh `id` and
    ///   name "\(originalName)-subN", preserving only the cells and
    ///   ports within that component.
    func decomposeSubgraphs() -> [RepStruct] {
        var result: [RepStruct] = []
        var visited: Set<RepID> = []

        // Iterate every cell; if unvisited, BFS its component
        for startID in cells.keys where !visited.contains(startID) {
            // 1) Perform BFS to collect all cell IDs in this component
            var componentIDs: [RepID] = []
            var queue: [RepID] = [startID]
            visited.insert(startID)

            while let id = queue.first {
                queue.removeFirst()
                componentIDs.append(id)

                // Enqueue neighbors via all outgoing ports
                for (_, neighbor) in cells[id]?.ports ?? [:] {
                    if !visited.contains(neighbor) {
                        visited.insert(neighbor)
                        queue.append(neighbor)
                    }
                }
            }

            // 2) Build a new RepStruct containing only those cells/ports
            let newRepID = RepID()
            var subRep = RepStruct(id: newRepID, name: "\(name)-sub\(result.count)")

            // Copy each cell and its intra-component ports
            for id in componentIDs {
                if var cell = cells[id] {
                    // Filter ports to only those targeting within this component
                    cell.ports = cell.ports.filter { componentIDs.contains($0.value) }
                    subRep = subRep.adding(cell)
                }
            }

            result.append(subRep)
        }

        return result
    }
}
