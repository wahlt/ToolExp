//
//  Investigate.swift
//  InvestigateKit
//
//  Specification:
//  • Drives an investigation batch: mutates, evaluates, selects best.
//
//  Discussion:
//  Sequence: generate variants, evaluate each, return top variant.
//
//  Rationale:
//  • Encapsulates common “what-if” loop for Tool’s exploration.
//  Dependencies: Evaluate
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum Investigate {
    /// Returns the best-scoring variant Rep ID.
    public static func bestVariant(for repID: UUID,
                                   variants: [(UUID) async throws -> UUID]) async throws -> UUID {
        var bestID = repID
        var bestScore = -Double.infinity
        for mutate in variants {
            let vid = try await mutate(repID)
            let report = try await Evaluate.report(for: vid)
            if report.density > bestScore {
                bestScore = report.density
                bestID = vid
            }
        }
        return bestID
    }
}
