//
//  RepStruct.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Core data model for a graph of Cells.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Holds unique ID, cell array, and optional metadata.
//  4. Usage
//     Used throughout ToolExp as central model.
//  5. Notes
//     Codable for persistence and network sync.

import Foundation

/// Represents an entire replication graph (Rep).
public struct RepStruct: RepProtocol, Identifiable {
    public let id: UUID
    public var cells: [Cell]
    public var metadata: [String: AnyCodable]

    /// Initializes a new, empty RepStruct.
    public init(
        id: UUID = .init(),
        cells: [Cell] = [],
        metadata: [String: AnyCodable] = [:]
    ) {
        self.id = id
        self.cells = cells
        self.metadata = metadata
    }
}
