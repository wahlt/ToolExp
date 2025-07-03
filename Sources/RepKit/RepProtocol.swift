//
//  RepProtocol.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Defines a protocol for RepStruct-like types.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Requires unique ID and cell array.
//  4. Usage
//     Allows alternative implementations of RepStruct.
//  5. Notes
//     May be extended for streaming or CRDT replicas.

import Foundation

/// Protocol for types representing a Rep graph structure.
public protocol RepProtocol: Codable {
    var id: UUID { get }
    var cells: [Cell] { get set }
}
