//
//  RepProtocol.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepProtocol.swift
// RepKit — Core protocol and types for Rep containers.
//

import Foundation

/// Globally‐unique identifier for Reps, Cells, etc.
public typealias RepID = UUID

/// Defines the minimal interface for a graph container.
public protocol RepProtocol: Codable, Sendable {
    /// The unique ID of the Rep.
    var id: RepID { get }
    /// Human‐readable name.
    var name: String { get set }
    /// Mapping from cell IDs → Cell objects.
    var cells: [RepID: Cell] { get set }

    /// Add a new `Cell` to the Rep, returning the new Rep.
    func adding(_ cell: Cell) -> Self

    /// Remove a cell by ID, returning the new Rep.
    func removing(cellID: RepID) throws -> Self

    /// Apply a `RepUpdate` to this Rep.
    func applying(_ update: RepUpdate) throws -> Self
}

/// Errors that apply to protocol‐level operations.
public enum RepError: Error, LocalizedError {
    case cellNotFound(RepID)
    case updateFailed

    public var errorDescription: String? {
        switch self {
        case .cellNotFound(let id):
            return "Cell \(id) not found."
        case .updateFailed:
            return "Failed to apply RepUpdate."
        }
    }
}
