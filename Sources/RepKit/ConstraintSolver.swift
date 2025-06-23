// File: Sources/RepKit/ConstraintSolver.swift
//  RepKit
//
//  Specification:
//  • Provides a topological sort algorithm for directed graphs of type `T`.
//  • Throws on cycle detection via `ConstraintError.cycleDetected`.
//
//  Discussion:
//  Uses an array-based queue (FIFO) and an in-degree map to process vertices.
//  Vertices with zero in-degree are enqueued, removed, and their outgoing edges “deleted”
//  by decrementing in-degree counts, enqueuing newly zero in-degree vertices, until done.
//
//  Rationale:
//  • Essential for ordering operations (e.g., cell updates, dependency resolution).
//  • Array queue preserves a deterministic processing order.
//  • Generic over `Hashable` allows use with any vertex type.
//
//  TODO:
//  • Expose partial ordering when cycles exist instead of a boolean error.
//  • Optimize for sparse vs dense graphs with different data structures.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Errors thrown by the topological sort solver.
public enum ConstraintError: Error {
    /// Indicates that the graph contains a cycle.
    case cycleDetected
}

/// Provides a topological sorting algorithm for directed graphs of `T`.
public struct ConstraintSolver<T: Hashable> {
    /// Computes a topological ordering of the given directed edges.
    ///
    /// - Parameter edges: Array of `(from, to)` pairs representing the graph.
    /// - Returns: Array of vertices in topologically sorted order.
    /// - Throws: `ConstraintError.cycleDetected` if the graph contains a cycle.
    public static func topologicalSort(_ edges: [(T, T)]) throws -> [T] {
        // 1) Collect all unique vertices
        var vertices = Set<T>()
        for (u, v) in edges {
            vertices.insert(u)
            vertices.insert(v)
        }

        // 2) Compute in-degree count for each vertex
        var inDegree = [T: Int]()
        vertices.forEach { inDegree[$0] = 0 }
        for (_, v) in edges {
            inDegree[v, default: 0] += 1
        }

        // 3) Initialize FIFO queue with zero in-degree vertices
        var queue: [T] = []
        for (v, deg) in inDegree where deg == 0 {
            queue.append(v)
        }

        var sorted: [T] = []

        // 4) Process the queue
        while !queue.isEmpty {
            let v = queue.removeFirst()
            sorted.append(v)
            // Remove outgoing edges and update in-degrees
            for (from, to) in edges where from == v {
                inDegree[to]! -= 1
                if inDegree[to]! == 0 {
                    queue.append(to)
                }
            }
        }

        // 5) If sorted count mismatches vertices count, a cycle exists
        if sorted.count != vertices.count {
            throw ConstraintError.cycleDetected
        }

        return sorted
    }
}
