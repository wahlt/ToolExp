//
//  ConstraintSolver.swift
//  RepKit
//
//  Specification:
//  • Solves directed‐acyclic dependency constraints via topological sort.
//  • Throws if cycles detected.
//
//  Discussion:
//  Some Rep uses require ordering constraints—e.g., build pipelines.
//  ConstraintSolver turns (A→B) edges into linear execution orders.
//
//  Rationale:
//  • Kahn’s algorithm is efficient and well understood.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum ConstraintSolverError: Error {
    case cycleDetected
}

public enum ConstraintSolver {
    /// Returns an order of elements respecting directed edges.
    /// - Parameters:
    ///   - items: all nodes
    ///   - edges: tuples (from, to)
    public static func topologicalSort<T: Hashable>(
        items: Set<T>,
        edges: [(T, T)]
    ) throws -> [T] {
        var inDegree = [T: Int]()
        var graph = [T: [T]]()
        for item in items {
            inDegree[item] = 0; graph[item] = []
        }
        for (u, v) in edges {
            graph[u]?.append(v)
            inDegree[v]? += 1
        }
        var queue = items.filter { inDegree[$0] == 0 }
        var order: [T] = []
        while !queue.isEmpty {
            let u = queue.removeFirst()
            order.append(u)
            for v in graph[u]! {
                inDegree[v]! -= 1
                if inDegree[v]! == 0 {
                    queue.append(v)
                }
            }
        }
        if order.count != items.count {
            throw ConstraintSolverError.cycleDetected
        }
        return order
    }
}
