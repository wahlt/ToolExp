// File: Sources/RepKit/RepUpdate.swift
//  RepKit
//
//  Specification:
//  • Enumerates graph-mutation operations on RepStruct cells.
//  • Conforms to Codable and Sendable for actor-safe update streams.
//
//  Discussion:
//  Each case carries AnyCodable metadata, which is Sendable by extension above.
//  The `applying(to:)` helper returns a new RepStruct with this update applied.
//
//  Rationale:
//  • Immutable update enum simplifies undo/redo and event sourcing.
//  • Sendable conformance silences actor isolation warnings in RepStructActor.
//
//  TODO:
//  • Add move/rename port cases and batch update variants for performance.
//
//  Dependencies: Foundation, AnyCodable
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum RepUpdate: Codable, Sendable {
    /// Add a new cell with given ID, metadata, and ports
    case addCell(id: UUID, data: [String: AnyCodable], ports: [String: UUID])
    /// Remove the cell with the given ID
    case removeCell(id: UUID)
    /// Update one metadata key/value in an existing cell
    case updateData(id: UUID, key: String, value: AnyCodable)

    /// Returns a new RepStruct with this update applied
    public func applying(to rep: RepStruct) -> RepStruct {
        var r = rep
        switch self {
        case let .addCell(id, data, ports):
            let newCell = Cell(id: id, ports: ports, data: data)
            r.cells.append(newCell)
        case let .removeCell(id):
            r.cells.removeAll { $0.id == id }
        case let .updateData(id, key, value):
            if let idx = r.cells.firstIndex(where: { $0.id == id }) {
                r.cells[idx].data[key] = value
            }
        }
        return r
    }
}
