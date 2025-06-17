//
//  Investigate.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Investigate.swift
// InvestigateKit — Deep-dive investigation & profiling tools.
//
// Responsibilities:
//
//  1. Generate graph metrics and reports.
//  2. Time-series extraction for simulation states.
//  3. Interface with MetricKit / Instruments when available.
//

import Foundation
import RepKit

public final class Investigate {
    public init() {}

    /// Compute core graph metrics (cell count, density, max depth).
    public func graphMetrics(for rep: RepStruct) -> [String: Any] {
        // TODO:
        // 1. cellCount = rep.cells.count
        // 2. maxDepth via BFS/DFS traversal.
        // 3. avgDegree = totalPorts / cellCount.
        return [:]
    }

    /// Extract a time-series of a custom property over simulation steps.
    public func timeSeries<T>(
        property: @escaping (RepStruct) -> T,
        initialRep: RepStruct,
        steps: Int,
        dt: TimeInterval
    ) -> [T] {
        var results: [T] = []
        var rep = initialRep
        for _ in 0..<steps {
            results.append(property(rep))
            // TODO: step physics via PhysEngAdapter or ChronosKit.
        }
        return results
    }
}
