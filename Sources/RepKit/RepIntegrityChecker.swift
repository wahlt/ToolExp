// RepIntegrityChecker.swift
// Detects cycles (and optionally unreachable cells) in a RepStruct.

import Foundation
import RepKit

public struct RepIntegrityChecker {
    public enum IntegrityError: Error {
        case cycleDetected([UUID])
        case unreachableCells([UUID])
    }

    /// Throws if the Rep has a cycle (or unreachable cells, if enabled).
    public static func check(rep: RepStruct) throws {
        // 1) Cycle detection via DFS
        var visited = Set<UUID>()
        var stack   = [UUID]()

        func dfs(_ id: UUID) -> IntegrityError? {
            if stack.contains(id) {
                // cycle found
                return .cycleDetected(stack + [id])
            }
            if visited.contains(id) {
                return nil
            }
            visited.insert(id)
            stack.append(id)
            defer { stack.removeLast() }

            guard let cell = rep.cells[id] else { return nil }
            let neighbors = cell.outgoingEdges.map(\.targetID)
            for neigh in neighbors {
                if let err = dfs(neigh) {
                    return err
                }
            }
            return nil
        }

        for id in rep.cells.keys {
            if let err = dfs(id) {
                throw err
            }
        }

        // 2) Unreachable detection (commented until depthFirst is implemented)
        /*
        guard let root = rep.cells.keys.first else { return }
        let reachable = Set(rep.depthFirst(from: root).map(\.id))
        let unreachable = Set(rep.cells.keys).subtracting(reachable)
        if !unreachable.isEmpty {
            throw IntegrityError.unreachableCells(Array(unreachable))
        }
        */
    }
}
