//
//  Cell.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Represents a node in a Rep graph with position and metadata.
//  2. Dependencies
//     Foundation, CoreGraphics
//  3. Overview
//     `Cell` holds an identifier, a 2D position, and dynamic metadata.
//  4. Usage
//     Used by RepStruct to model graph nodes.
//  5. Notes
//     Metadata values are wrapped in `AnyCodable`.

import Foundation
import CoreGraphics

/// A node in the Rep graph.
public struct Cell: Codable, Identifiable {
    public let id: UUID
    public var position: CGPoint
    public var metadata: [String: AnyCodable]

    /// Initializes a Cell with optional metadata.
    public init(
        id: UUID = .init(),
        position: CGPoint,
        metadata: [String: AnyCodable] = [:]
    ) {
        self.id = id
        self.position = position
        self.metadata = metadata
    }
}
