//
//  RepUpdate.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepUpdate.swift
// RepKit — Encodes atomic updates to a Rep.
//
// Use with `RepStruct.applying(_:)` to mutate Reps functionally.
//

import Foundation

/// Represents a single atomic change to a RepStruct.
public enum RepUpdate: Codable {
    /// Rename a cell’s label.
    case renameCell(id: RepID, newLabel: String)
    /// Change a cell’s data payload.
    case updateData(id: RepID, newData: AnyCodable)
    /// Connect a port.
    case connect(id: RepID, port: String, to: RepID)
    /// Disconnect a port.
    case disconnect(id: RepID, port: String)

    // Codable synthesis provides correct JSON representation.
}
