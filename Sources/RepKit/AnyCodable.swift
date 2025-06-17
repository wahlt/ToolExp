//
//  AnyCodable.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AnyCodable.swift
// RepKit — A drop-in type-erased Codable wrapper (community-style).
//
// Replaces the old CodableValue/BoxImpl boilerplate.
//

import Foundation

/// A type-erased Codable & Hashable value.
/// Supports Int, Double, Bool, String, Array, Dictionary, and nested structures.
public struct AnyCodable: Codable, Hashable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    // MARK: – Decoding

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.value = ()
        } else if let intVal = try? container.decode(Int.self) {
            self.value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            self.value = doubleVal
        } else if let boolVal = try? container.decode(Bool.self) {
            self.value = boolVal
        } else if let stringVal = try? container.decode(String.self) {
            self.value = stringVal
        } else if let arr = try? container.decode([AnyCodable].self) {
            self.value = arr.map(\.value)
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            self.value = dict.mapValues(\.value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported type in AnyCodable"
            )
        }
    }

    // MARK: – Encoding

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is Void:
            try container.encodeNil()
        case let intVal as Int:
            try container.encode(intVal)
        case let doubleVal as Double:
            try container.encode(doubleVal)
        case let boolVal as Bool:
            try container.encode(boolVal)
        case let stringVal as String:
            try container.encode(stringVal)
        case let arr as [Any]:
            try container.encode(arr.map(AnyCodable.init))
        case let dict as [String: Any]:
            try container.encode(dict.mapValues(AnyCodable.init))
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "AnyCodable value cannot be encoded"
            )
            throw EncodingError.invalidValue(value, context)
        }
    }

    // MARK: – Hashable

    public func hash(into hasher: inout Hasher) {
        switch value {
        case let intVal as Int:
            hasher.combine(intVal)
        case let doubleVal as Double:
            hasher.combine(doubleVal)
        case let boolVal as Bool:
            hasher.combine(boolVal)
        case let stringVal as String:
            hasher.combine(stringVal)
        default:
            hasher.combine(String(describing: value))
        }
    }
}
