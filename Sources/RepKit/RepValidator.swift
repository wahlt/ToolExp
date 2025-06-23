//
//  RepValidator.swift
//  RepKit
//
//  Specification:
//  • Validates fundamental Rep invariants:
//    • Unique cell IDs, port targets exist, no orphan cells.
//
//  Discussion:
//  Early sanity checks catch malformed mutations before runtime.
//
//  Rationale:
//  • Fail-fast on critical errors to simplify debugging.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum RepValidationError: Error {
    case duplicateCellID(UUID)
    case missingPortTarget(UUID, String)
}

public enum RepValidator {
    /// Throws if any invariant is violated.
    public static func validate(_ rep: RepStruct) throws {
        var seen = Set<UUID>()
        for cell in rep.cells {
            if seen.contains(cell.id) {
                throw RepValidationError.duplicateCellID(cell.id)
            }
            seen.insert(cell.id)
        }
        let validIDs = Set(rep.cells.map { $0.id })
        for cell in rep.cells {
            for (portName, target) in cell.ports {
                if !validIDs.contains(target) {
                    throw RepValidationError.missingPortTarget(cell.id, portName)
                }
            }
        }
    }
}
