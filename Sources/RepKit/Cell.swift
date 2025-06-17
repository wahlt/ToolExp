//
//  Cell.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Cell.swift
// RepKit — Value-type graph node representing a single cell.
// Switched from class to struct for value semantics & Sendable conformance.
//

import Foundation

/// Unique identifier for cells & reps.
public typealias RepID = UUID

/// Protocol for a graph node in a RepStruct.
public protocol CellProtocol: Codable, Hashable, Sendable {
    /// Globally unique cell ID.
    var id: RepID { get }
    /// Short textual label for display.
    var label: String { get set }
    /// Arbitrary payload.
    var data: AnyCodable { get set }
    /// Named ports mapping to other cell IDs.
    var ports: [String: RepID] { get set }
}

/// Concrete, Codable, Hashable, Sendable cell.
public struct Cell: CellProtocol {
    public let id: RepID
    public var label: String
    public var data: AnyCodable
    public var ports: [String: RepID]

    /// Create a new Cell.
    ///
    /// - Parameters:
    ///   - id:    optional custom UUID (default new).
    ///   - label: display name for the cell.
    ///   - data:  payload, default empty.
    ///   - ports: edge map, default empty.
    public init(
        id: RepID = RepID(),
        label: String,
        data: AnyCodable = AnyCodable(()),
        ports: [String: RepID] = [:]
    ) {
        self.id = id
        self.label = label
        self.data = data
        self.ports = ports
    }
}
