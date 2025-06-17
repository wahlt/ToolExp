//
//  Traverse.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Traverse.swift
// DataServ — Graph traversal utilities for RepStruct.
//
// Implements both breadth‐first and depth‐first search.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Breadth‐first traversal starting at `startID`.
    ///
    /// - Returns: array of `Cell` in BFS order.
    func breadthFirst(from startID: RepID) -> [Cell] {
        var result: [Cell] = []
        var queue: [RepID] = [startID]
        var visited: Set<RepID> = [startID]

        while !queue.isEmpty {
            let id = queue.removeFirst()
            guard let cell = cells[id] else { continue }
            result.append(cell)
            for (_, neighbor) in cell.ports {
                if !visited.contains(neighbor) {
                    visited.insert(neighbor)
                    queue.append(neighbor)
                }
            }
        }

        return result
    }

    /// Depth‐first traversal starting at `startID`.
    ///
    /// - Returns: array of `Cell` in DFS pre‐order.
    func depthFirst(from startID: RepID) -> [Cell] {
        var result: [Cell] = []
        var visited: Set<RepID> = []

        func dfs(_ id: RepID) {
            guard let cell = cells[id], !visited.contains(id) else { return }
            visited.insert(id)
            result.append(cell)
            for (_, neighbor) in cell.ports {
                dfs(neighbor)
            }
        }

        dfs(startID)
        return result
    }
}
