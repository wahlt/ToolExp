//
//  AnyCodable.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Provides a type-erased wrapper for heterogeneous Codable values.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Encapsulates `Any` with full Codable, Hashable, Hashable support.
//  4. Usage
//     Use as container for dynamic metadata in RepKit types.
//  5. Notes
//     Derived from Flight-School/AnyCodable; extended with full basic types.

import Foundation

/// A type-erased `Codable` value. Supports Int, Double, Bool, String, arrays and dictionaries.
public struct AnyCodable: Codable, Hashable {
    public let value: Any

    /// Wraps any supported value.
    public init(_ value: Any) {
        self.value = value
    }

    // MARK: – Decoding

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() {
            self.value = ()
        } else if let v = try? c.decode(Bool.self) {
            self.value = v
        } else if let v = try? c.decode(Int.self) {
            self.value = v
        } else if let v = try? c.decode(Double.self) {
            self.value = v
        } else if let v = try? c.decode(String.self) {
            self.value = v
        } else if let arr = try? c.decode([AnyCodable].self) {
            self.value = arr.map(\.value)
        } else if let dict = try? c.decode([String:AnyCodable].self) {
            self.value = dict.mapValues(\.value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: c,
                debugDescription: "Unsupported AnyCodable type"
            )
        }
    }

    // MARK: – Encoding

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch value {
        case is Void:
            try c.encodeNil()
        case let v as Bool:
            try c.encode(v)
        case let v as Int:
            try c.encode(v)
        case let v as Double:
            try c.encode(v)
        case let v as String:
            try c.encode(v)
        case let arr as [Any]:
            try c.encode(arr.map(AnyCodable.init))
        case let dict as [String:Any]:
            try c.encode(dict.mapValues(AnyCodable.init))
        default:
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: c.codingPath,
                    debugDescription: "AnyCodable cannot encode \(type(of:value))"
                )
            )
        }
    }

    // MARK: – Hashable

    public func hash(into hasher: inout Hasher) {
        switch value {
        case let v as Bool:   hasher.combine(v)
        case let v as Int:    hasher.combine(v)
        case let v as Double: hasher.combine(v)
        case let v as String: hasher.combine(v)
        default:              hasher.combine(String(describing: value))
        }
    }

    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        // Compare stringified form for simplicity
        String(describing: lhs.value) == String(describing: rhs.value)
    }
}
