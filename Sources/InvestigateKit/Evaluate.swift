//
//  Evaluate.swift
//  InvestigateKit
//
//  Specification:
//  • Computes numerical metrics on Rep graphs (e.g., density).
//  • Returns a standardized report for ranking variants.
//
//  Discussion:
//  Investigation workflows compare multiple Rep mutations.
//  Evaluate provides uniform scoring for “best of N” selection.
//
//  Rationale:
//  • Decouples metric logic from UI or pipeline code.
//  Dependencies: RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit

public struct EvaluationReport {
    public let nodeCount: Int
    public let edgeCount: Int
    public let density: Double
}

public enum Evaluate {
    /// Produces an evaluation report for a given Rep.
    public static func report(for repID: UUID) async throws -> EvaluationReport {
        let (nodes, edges) = try await RepStruct.shared.loadGraph(for: repID)
        let n = nodes.count, m = edges.count
        let dens = m == 0 ? 0 : Double(m) / Double(n*(n-1)/2)
        return EvaluationReport(nodeCount: n, edgeCount: m, density: dens)
    }
}
