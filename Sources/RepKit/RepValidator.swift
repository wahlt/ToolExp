//
//  RepValidator.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepValidator.swift
// RepKit — Ensures no dangling ports in a Rep.
//
// Extensible for future cycle‐detection or trait validation.
//

import Foundation

/// Errors discovered during validation.
public enum RepValidationError: Error, LocalizedError {
    /// A cell’s named port refers to a target ID that doesn’t exist.
    case danglingPort(cell: RepID, port: String, target: RepID)

    public var errorDescription: String? {
        switch self {
        case .danglingPort(let cell, let port, let target):
            return "Cell \(cell) port ‘\(port)’ points to missing cell \(target)."
        }
    }
}

/// Performs lightweight consistency checks on a `RepStruct`.
public struct RepValidator {
    /// Validate core invariants.
    ///
    /// - Parameter rep: the `RepStruct` to check.
    /// - Returns: first `RepValidationError` found, or `nil` if valid.
    public static func validate(_ rep: RepStruct) -> RepValidationError? {
        for (cellID, cell) in rep.cells {
            for (portName, targetID) in cell.ports {
                if rep.cells[targetID] == nil {
                    return .danglingPort(
                        cell: cellID,
                        port: portName,
                        target: targetID
                    )
                }
            }
        }
        return nil
    }
}
