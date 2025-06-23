// File: Sources/RepKit/AnyCodable.swift
//  RepKit
//
//  Specification:
//  • A wrapper for encoding/decoding heterogeneous values (Int, Double, Bool, String).
//  • Provides manual Equatable and unchecked Sendable conformance.
//
//  Discussion:
//  Because `Any` cannot itself conform to Equatable, we manually implement `==`
//  for supported underlying types. Declaring `@unchecked Sendable` silences
//  concurrency-safety errors when `[String:AnyCodable]` is used in Sendable contexts.
//
//  Rationale:
//  • Enables storing arbitrary simple metadata in `Cell.data` dictionaries.
//  • Prevents compiler errors about non-Equatable stored properties in Equatable structs.
//  • Balances flexibility with safety through explicit type support.
//
//  TODO:
//  • Extend support to Date, nested arrays, and dictionaries of `AnyCodable`.
//  • Add optional performance optimizations or a type whitelist for safety.
//
//  Dependencies: Foundation
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct AnyCodable: Codable {
    /// The wrapped value of unknown type.
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let dblVal = try? container.decode(Double.self) {
            value = dblVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else if let strVal = try? container.decode(String.self) {
            value = strVal
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "AnyCodable: Unsupported type"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as Int:    try container.encode(v)
        case let v as Double: try container.encode(v)
        case let v as Bool:   try container.encode(v)
        case let v as String: try container.encode(v)
        default:
            throw EncodingError.invalidValue(
                value,
                .init(
                    codingPath: encoder.codingPath,
                    debugDescription: "AnyCodable: Unsupported type"
                )
            )
        }
    }

    /// Manual equality only on supported underlying types.
    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (a as Int,    b as Int):    return a == b
        case let (a as Double, b as Double): return a == b
        case let (a as Bool,   b as Bool):   return a == b
        case let (a as String, b as String): return a == b
        default: return false
        }
    }
}

extension AnyCodable: Equatable {}
extension AnyCodable: @unchecked Sendable {}
