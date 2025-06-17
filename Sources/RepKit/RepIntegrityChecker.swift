//
//  RepIntegrityChecker.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepIntegrityChecker.swift
// RepKit — Advanced integrity checks on a RepStruct.
//
// Ensures no cycles, no unreachable cells, etc.
//

import Foundation

/// Errors thrown when integrity checks fail.
public enum IntegrityError: Error, LocalizedError {
    case cycleDetected(path: [RepID])
    case unreachableCells([RepID])

    public var errorDescription: String? {
        switch self {
        case .cycleDetected(let path):
            return "Cycle detected: \(path)"
        case .unreachableCells(let ids):
            return "Unreachable cells found: \(ids)"
        }
    }
}

/// Performs deep consistency checks beyond `RepValidator`.
public struct RepIntegrityChecker {
    /// Checks for cycles and unreachable nodes.
    /// - Parameter rep: the RepStruct to inspect.
    /// - Returns: first `IntegrityError` found, or `nil` if fully integral.
    public static func validate(_ rep: RepStruct) -> IntegrityError? {
        // 1. Cycle detection via DFS with stack tracking.
        var visited = Set<RepID>()
        var stack   = [RepID]()

        func dfs(_ id: RepID) -> IntegrityError? {
            if stack.contains(id) {
                let cycleStart = stack.firstIndex(of: id)!
                return .cycleDetected(path: Array(stack[cycleStart...] + [id]))
            }
            guard !visited.contains(id) else { return nil }
            visited.insert(id)
            stack.append(id)
            for (_, neighbor) in rep.cells[id]?.ports ?? [:] {
                if let err = dfs(neighbor) { return err }
            }
            stack.removeLast()
            return nil
        }

        for id in rep.cells.keys {
            if let cycleErr = dfs(id) { return cycleErr }
        }

        // 2. Unreachable detection: start from rep.id as root.
        let reachable = Set(rep.depthFirst(from: rep.cells.keys.first!/*choose any*/).map(\.id))
        let unreachable = Set(rep.cells.keys).subtracting(reachable)
        if !unreachable.isEmpty {
            return .unreachableCells(Array(unreachable))
        }

        return nil
    }
}
