// File: Sources/InvestigateKit/Evaluate.swift
//  InvestigateKit
//
//  Specification:
//  • Defines `EvaluationReport` and `RepEvaluator` to analyze RepStruct graphs.
//
//  Discussion:
//  Imports RepKit (now declared as a dependency) to access Cell and RepStruct.
//  Performs cycle detection and topological sort, returning metrics in the report.
//
//  Rationale:
//  • Centralizes analysis logic for debugging overlays and diagnostics.
//  • Codable & Sendable conformance allows report transport across actor contexts.
//
//  TODO:
//  • Expose cycle paths and depth metrics in the report.
//  • Integrate with HUDOverlayManager for in-app visualization.
//
//  Dependencies: Foundation, RepKit
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit

public struct EvaluationReport: Codable, Sendable {
    public let isAcyclic: Bool
    public let sortedIDs: [UUID]
    public let errors:    [Error]
}

public struct RepEvaluator {
    /// Analyze the rep and produce an `EvaluationReport`.
    public static func evaluate(rep: RepStruct) -> EvaluationReport {
        var errors: [Error] = []
        do {
            try RepIntegrityChecker.check(rep)
        } catch {
            errors.append(error)
        }
        let acyclic = errors.isEmpty
        var sorted: [UUID] = []
        if acyclic {
            let edges = rep.cells.flatMap { cell in
                cell.ports.values.map { (cell.id, $0) }
            }
            do {
                sorted = try ConstraintSolver.topologicalSort(edges)
            } catch {
                errors.append(error)
            }
        }
        return EvaluationReport(
            isAcyclic: acyclic,
            sortedIDs: sorted,
            errors:    errors
        )
    }
}
