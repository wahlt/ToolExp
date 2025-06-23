//
//  RepUpdate.swift
//  RepKit
//
//  Specification:
//  • Enumerates mutation operations on RepStruct.
//  • Each case can `apply` itself to produce a new RepStruct.
//
//  Discussion:
//  Enables recording user actions as replayable update sequences.
//
//  Rationale:
//  • Functional-style updates simplify undo/redo and history.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum RepUpdate: Codable {
    case addCell(id: UUID, data: [String: AnyCodable])
    case removeCell(id: UUID)
    case updateCellData(id: UUID, data: [String: AnyCodable])
    case addPort(source: UUID, portName: String, target: UUID)
    case removePort(source: UUID, portName: String)

    /// Applies this update to a RepStruct, returning the modified copy.
    public func applying(to rep: RepStruct) -> RepStruct {
        var rep = rep
        switch self {
        case let .addCell(id, data):
            let cell = Cell(id: id, data: data, ports: [:])
            rep.cells.append(cell)
        case let .removeCell(id):
            rep.cells.removeAll { $0.id == id }
        case let .updateCellData(id, data):
            if let idx = rep.cells.firstIndex(where: { $0.id == id }) {
                rep.cells[idx].data.merge(data) { _, new in new }
            }
        case let .addPort(source, portName, target):
            if let idx = rep.cells.firstIndex(where: { $0.id == source }) {
                rep.cells[idx].ports[portName] = target
            }
        case let .removePort(source, portName):
            if let idx = rep.cells.firstIndex(where: { $0.id == source }) {
                rep.cells[idx].ports.removeValue(forKey: portName)
            }
        }
        return rep
    }
}
