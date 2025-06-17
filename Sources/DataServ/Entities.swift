//
//  Entities.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Entities.swift
// DataServ — SwiftData @Model entities for RepStruct persistence.
//
// Maps 1:1 to in-memory RepStruct, Cell, and Port types.
//

import SwiftData
import Foundation

/// Represents an entire RepStruct in the persistent store.
@Model
public class RepEntity {
    /// Matches `RepStruct.id`
    @Attribute(.unique) public var id: UUID
    /// Matches `RepStruct.name`
    public var name: String
    /// One-to-many relationship with cells (cascade delete).
    @Relationship(deleteRule: .cascade) public var cells: [CellEntity]

    public init(
        id: UUID = .init(),
        name: String,
        cells: [CellEntity] = []
    ) {
        self.id = id
        self.name = name
        self.cells = cells
    }
}

/// Represents a single Cell in a RepStruct.
@Model
public class CellEntity {
    @Attribute(.unique) public var id: UUID          // Cell id
    public var label: String                         // Cell label
    /// Serialized `AnyCodable` payload
    public var data: Data?
    @Relationship(deleteRule: .cascade) public var ports: [PortEntity]

    public init(
        id: UUID = .init(),
        label: String,
        data: Data? = nil,
        ports: [PortEntity] = []
    ) {
        self.id = id
        self.label = label
        self.data = data
        self.ports = ports
    }
}

/// Represents a directed port (edge) from one cell to another.
@Model
public class PortEntity {
    @Attribute(.unique) public var id: UUID       // Unique for SwiftData
    public var name: String                       // Port name/label
    public var targetID: UUID                     // The cell this port points to

    public init(
        id: UUID = .init(),
        name: String,
        targetID: UUID
    ) {
        self.id = id
        self.name = name
        self.targetID = targetID
    }
}
