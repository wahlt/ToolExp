//
//  RepStruct.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepStruct.swift
// RepKit — Concrete, Codable container for a Rep graph.
//

import Foundation

/// A concrete implementation of `RepProtocol`.
public struct RepStruct: RepProtocol {
    public let id: RepID
    public var name: String
    public var cells: [RepID: Cell]

    /// Create an empty Rep with just a name.
    public init(id: RepID = .init(), name: String, cells: [RepID: Cell] = [:]) {
        self.id = id
        self.name = name
        self.cells = cells
    }

    /// Add a cell, returning a new Rep with the cell inserted.
    public func adding(_ cell: Cell) -> RepStruct {
        var copy = self
        copy.cells[cell.id] = cell
        return copy
    }

    /// Remove a cell and all ports pointing to it.
    public func removing(cellID: RepID) throws -> RepStruct {
        guard cells[cellID] != nil else {
            throw RepError.cellNotFound(cellID)
        }
        var copy = self
        copy.cells[cellID] = nil
        // Remove incoming ports
        for (id, var c) in copy.cells {
            c.ports = c.ports.filter { $0.value != cellID }
            copy.cells[id] = c
        }
        return copy
    }

    /// Apply a single `RepUpdate` and return the new Rep.
    public func applying(_ update: RepUpdate) throws -> RepStruct {
        switch update {
        case .renameCell(let id, let newLabel):
            return try renaming(cell: id, to: newLabel)
        case .updateData(let id, let newData):
            return try updatingData(of: id, to: newData)
        case .connect(let id, let port, let to):
            return try connecting(cell: id, port: port, to: to)
        case .disconnect(let id, let port):
            return try disconnecting(cell: id, port: port)
        }
    }
}
