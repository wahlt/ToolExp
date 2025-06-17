//
//  AsyncTraverse.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AsyncTraverse.swift
// DataServ — AsyncSequence BFS & DFS for large Reps.
//
// Leverages Swift 6.2 AsyncSequence improvements.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Async BFS over the cell graph.
    /// Yields each visited Cell as it’s discovered.
    func asyncBreadthFirst(from startID: RepID) -> AsyncStream<Cell> {
        AsyncStream { cont in
            Task.detached {
                var visited: Set<RepID> = [startID]
                var queue: [RepID] = [startID]
                while !queue.isEmpty {
                    let id = queue.removeFirst()
                    guard let cell = cells[id] else { continue }
                    cont.yield(cell)
                    for (_, neighbor) in cell.ports where !visited.contains(neighbor) {
                        visited.insert(neighbor)
                        queue.append(neighbor)
                    }
                }
                cont.finish()
            }
        }
    }

    /// Async DFS over the cell graph.
    func asyncDepthFirst(from startID: RepID) -> AsyncStream<Cell> {
        AsyncStream { cont in
            Task.detached {
                var visited: Set<RepID> = []
                func dfs(_ id: RepID) {
                    guard !visited.contains(id), let cell = cells[id] else { return }
                    visited.insert(id)
                    cont.yield(cell)
                    for (_, neighbor) in cell.ports {
                        dfs(neighbor)
                    }
                }
                dfs(startID)
                cont.finish()
            }
        }
    }
}
