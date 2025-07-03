//
//  RepUpdate.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Captures discrete updates to a RepStruct over time.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Holds ID, timestamp, and description of a change.
//  4. Usage
//     StageKit publishes RepUpdates for Chronicle views.
//  5. Notes
//     Can be extended to include before/after diffs.

import Foundation

/// A record of a single change applied to a RepStruct.
public struct RepUpdate: Codable, Identifiable {
    public let id: UUID
    public let timestamp: Date
    public let description: String

    /// Initializes a RepUpdate.
    public init(
        id: UUID = .init(),
        timestamp: Date = .init(),
        description: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.description = description
    }
}
