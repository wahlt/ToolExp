//
//  ArchEng.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/1/25.
//

// Sources/BridgeKit/ArchEng.swift
//
//  ArchEng.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Default, minimal ArchEngProtocol implementation:
//  • Always suggests adding the identity trait to the issue’s node.
//

import Foundation
import RepKit

/// Concrete Architecture Engine that makes the simplest
/// possible proof-step suggestions.
public final class ArchEng: ArchEngProtocol {
    /// Initialize the engine (no configuration needed).
    public init() {}

    /// Suggest the next proof step for a validation issue.
    ///
    /// Here we always return the `IdentityTrait` on the same node.
    public func suggestNextProofStep(
        for rep: RepStruct,
        issue: RepValidator.ValidationIssue
    ) -> ArchEngSuggestion {
        // IdentityTrait is a no-op trait defined in RepKit.
        return ArchEngSuggestion(
            trait: IdentityTrait.self,
            node: issue.node
        )
    }
}
