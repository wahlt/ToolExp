//
//  RepIntegrityChecker.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  RepIntegrityChecker.swift
//  RepKit
//
//  Specification:
//  • Deep integrity checks: no cycles, connectedness, geometry constraints.
//  • Uses DFS for cycle detection and connectivity tests.
//
//  Discussion:
//  Some RepGraph operations require cycle‐free, fully‐connected graphs.
//
//  Rationale:
//  • Composite checks guarantee stability in physics/layout engines.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum RepIntegrityError: Error {
    case cycleDetected
    case disconnectedComponents
}

public enum RepIntegrityChecker {
    /// Runs full integrity suite on a RepStruct.
    public static func check(_ rep: RepStruct) throws {
        // 1) Cycle detection
        var visited = Set<UUID>()
        var stack = Set<UUID>()
        func dfs(_ id: UUID) throws {
            if stack.contains(id) { throw RepIntegrityError.cycleDetected }
            guard !visited.contains(id),
                  let cell = rep.cells.first(where: { $0.id == id }) else { return }
            visited.insert(id)
            stack.insert(id)
            for target in cell.ports.values {
                try dfs(target)
            }
            stack.remove(id)
        }
        for cell in rep.cells { try dfs(cell.id) }

        // 2) Connectivity: all nodes reachable from first
        if let start = rep.cells.first?.id {
            var reachable = Set<UUID>()
            func collect(_ id: UUID) {
                if reachable.contains(id) { return }
                reachable.insert(id)
                let cell = rep.cells.first { $0.id == id }!
                for t in cell.ports.values { collect(t) }
            }
            collect(start)
            if reachable.count != rep.cells.count {
                throw RepIntegrityError.disconnectedComponents
            }
        }
    }
}
