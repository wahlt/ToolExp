//
//  ArchEngProtocol.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/1/25.
//

// Sources/BridgeKit/ArchEngProtocol.swift
//
//  ArchEngProtocol.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Defines the protocol and suggestion type for the Architecture Engine.
//  • `ArchEngSuggestion` describes a trait-to-node application.
//  • `ArchEngProtocol` allows BridgeKit consumers to propose next proof steps.
//

import Foundation
import RepKit

/// Encapsulates a single “apply this trait to this node” suggestion.
public struct ArchEngSuggestion {
    /// The trait type to add.
    public let trait: Trait.Type
    /// The target node in the rep graph.
    public let node: RepNode

    /// Construct a suggestion.
    /// - Parameters:
    ///   - trait: A `Trait` subclass to apply.
    ///   - node:  The `RepNode` to which the trait will be added.
    public init(trait: Trait.Type, node: RepNode) {
        self.trait = trait
        self.node = node
    }
}

/// Protocol any Architecture Engine must conform to, enabling
/// suggestions to complete incomplete proofs in `RepStruct`s.
public protocol ArchEngProtocol {
    /// For a detected validation issue, propose the next proof step.
    ///
    /// - Parameters:
    ///   - rep:   The `RepStruct` under validation.
    ///   - issue: A `ValidationIssue` from `RepValidator`.
    /// - Returns: An `ArchEngSuggestion` indicating which trait to add.
    func suggestNextProofStep(
        for rep: RepStruct,
        issue: RepValidator.ValidationIssue
    ) -> ArchEngSuggestion
}
