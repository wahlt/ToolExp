//
//  Port.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Models a connection point on a Cell.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Holds port name and target cell ID.
//  4. Usage
//     RepValidator and scaffolding use Ports to connect cells.
//  5. Notes
//     Future: support multi-target ports.

import Foundation

/// Represents an outgoing or incoming link port on a Cell.
public struct Port: Codable, Hashable {
    public let name: String
    public let targetID: UUID

    /// Initializes a Port to link to a cell.
    public init(name: String, targetID: UUID) {
        self.name = name
        self.targetID = targetID
    }
}
