//
//  Port.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Port.swift
// RepKit — Core port‐connection API on RepStruct.
//
// Defines `RepError` and mutating port operations.
//

import Foundation

/// Unique identifier for Reps and Cells.
public typealias RepID = UUID

/// Errors for invalid Rep operations.
public enum RepError: Error, LocalizedError {
    /// Thrown when a cell ID is missing.
    case cellNotFound(RepID)
    /// Thrown when attempting to connect an invalid port.
    case invalidPort(name: String)

    public var errorDescription: String? {
        switch self {
        case .cellNotFound(let id):
            return "Cell with ID \(id) not found."
        case .invalidPort(let name):
            return "Port named '\(name)' is invalid."
        }
    }
}

/// Operations for connecting/disconnecting ports in a mutable Rep.
public protocol RepProtocol {
    /// The dictionary of cells.
    var cells: [RepID: Cell] { get set }

    /// Connect `sourceID`'s port `port` to `targetID`.
    /// - Throws: `RepError.cellNotFound` if either cell is absent.
    ///           `RepError.invalidPort` if `port` is invalid.
    mutating func connect(cell sourceID: RepID, port: String, to targetID: RepID) throws

    /// Disconnect port `port` on `sourceID`.
    /// - Throws: `RepError.cellNotFound` if the cell is absent.
    ///           `RepError.invalidPort` if the port does not exist.
    mutating func disconnect(cell sourceID: RepID, port: String) throws
}

/// Default implementations for any `RepProtocol`‐conforming type.
public extension RepProtocol {
    mutating func connect(cell sourceID: RepID, port: String, to targetID: RepID) throws {
        guard let src = cells[sourceID] else {
            throw RepError.cellNotFound(sourceID)
        }
        guard cells[targetID] != nil else {
            throw RepError.cellNotFound(targetID)
        }
        var updated = src
        // Cell.connect enforces no self‐edge and valid name.
        try updated.connect(port: port, to: targetID)
        cells[sourceID] = updated
    }

    mutating func disconnect(cell sourceID: RepID, port: String) throws {
        guard let src = cells[sourceID] else {
            throw RepError.cellNotFound(sourceID)
        }
        var updated = src
        updated.disconnect(port: port)
        cells[sourceID] = updated
    }
}
