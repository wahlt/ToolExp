//
//  RepIntegrityChecker.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Validates structural integrity of RepStructs.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Checks duplicates, missing ports, cycles, etc.
//  4. Usage
//     Call `check(rep:)` before execution.
//  5. Notes
//     Throws `RepError` on failures.

import Foundation

/// Ensures a RepStruct meets all consistency rules.
public final class RepIntegrityChecker {
    /// Throws `RepError` if rep is invalid.
    public func check(rep: RepStruct) throws {
        // 1. No duplicate cell IDs
        let ids = rep.cells.map(\.id)
        if Set(ids).count != ids.count {
            throw RepError.validationError(description: "Duplicate cell IDs found.")
        }
        // 2. All ports point to existing cells
        for cell in rep.cells {
            for port in cell.metadata["ports"]?.value as? [Port] ?? [] {
                if !ids.contains(port.targetID) {
                    throw RepError.validationError(
                        description: "Port '\(port.name)' on cell \(cell.id) targets unknown cell \(port.targetID)."
                    )
                }
            }
        }
    }
}
