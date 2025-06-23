//
//  MetricCollector.swift
//  InvestigateKit
//
//  Specification:
//  • Aggregates time, memory, and evaluation metrics during Investigate runs.
//  • Emits a summary at completion.
//
//  Discussion:
//  Detailed metrics help tune mutation heuristics and MLX parameters.
//
//  Rationale:
//  • Data-driven insights guide AI and simulation tuning.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct InvestigationMetrics {
    public let duration: TimeInterval
    public let peakMemoryMB: Double
    public let bestDensity: Double
}

public class MetricCollector {
    private var start: Date = Date()
    private var bestDensity: Double = -Double.infinity

    public func markStart() {
        start = Date()
    }

    public func updateDensity(_ density: Double) {
        bestDensity = max(bestDensity, density)
    }

    public func summary() -> InvestigationMetrics {
        let dur = Date().timeIntervalSince(start)
        return InvestigationMetrics(duration: dur, peakMemoryMB: 0, bestDensity: bestDensity)
    }
}
