//
//  ArchEngActor.swift
//  EngineKit
//
//  Orchestrates applying ArchEngProtocol recommendations
//  to a RepStruct in batch or per-issue.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit
import BridgeKit

/// Actor that drives the architecture engine, applying
/// suggested proof-step traits to a RepStruct.
public final class ArchEngActor {
    private let engine: ArchEngProtocol

    /// Initialize with any ArchEngProtocol implementation.
    public init(engine: ArchEngProtocol) {
        self.engine = engine
    }

    /// Validates and applies suggestions until no issues remain.
    /// - Parameter rep: In/out `RepStruct` to complete.
    public func completeProof(rep: inout RepStruct) throws {
        let validator = RepValidator()
        var issues = validator.validateProof(rep: rep)
        while !issues.isEmpty {
            for issue in issues {
                let suggestion = engine.suggestNextProofStep(for: rep, issue: issue)
                rep.addTrait(suggestion.trait, to: suggestion.node)
            }
            issues = validator.validateProof(rep: rep)
        }
    }
}
