//
//  RepSerializer.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Serializes and deserializes RepStruct to/from JSON.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Wraps JSONEncoder and JSONDecoder.
//  4. Usage
//     Call `serialize(rep:)` or `deserialize(data:)`.
//  5. Notes
//     Can be extended for binary formats.

import Foundation

/// Handles JSON encode/decode of RepStruct.
public final class RepSerializer {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    /// Produces JSON data from a RepStruct.
    public func serialize(rep: RepStruct) throws -> Data {
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(rep)
    }

    /// Parses JSON data into a RepStruct.
    public func deserialize(data: Data) throws -> RepStruct {
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(RepStruct.self, from: data)
    }
}
