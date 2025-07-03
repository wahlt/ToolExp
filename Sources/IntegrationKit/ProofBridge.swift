//
//  ProofBridge.swift
//  IntegrationKit
//
//  1. Purpose
//     Adds proof‐scaffolding methods to RepStruct.
// 2. Dependencies
//     RepKit
// 3. Overview
//     Enables proof scaffolding via MagicKit.

import Foundation
import RepKit

public extension RepStruct {
    /// Run full proof‐scaffolding on this replica.
    mutating func performProofScaffolding() throws {
        let scaffolder = DefaultMagicKitScaffolder(
            validator: RepValidator(),
            suggestor: ArchEngSuggestor()
        )
        try scaffolder.fillProofSteps(rep: self)
    }
}
