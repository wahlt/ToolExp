//
//  AnyCodable.swift
//  RepKit
//
//  Specification:
//  • Type‐erased wrapper for arbitrary Codable values.
//  • Supports encoding/decoding JSON primitives, arrays, and dictionaries.
//
//  Discussion:
//  Some Rep cell data or traits may be heterogeneous. AnyCodable
//  enables storing them in collections while retaining Codable conformance.
//
//  Rationale:
//  • Avoid proliferation of custom Codable enums for each payload shape.
//  • Facilitate JSON‐based serialization of dynamic Rep metadata.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct AnyCodable: Codable, Equatable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = NSNull()
        } else if let v = try? container.decode(Bool.self) {
            self.value = v
        } else if let v = try? container.decode(Int.self) {
            self.value = v
        } else if let v = try? container.decode(Double.self) {
            self.value = v
        } else if let v = try? container.decode(String.self) {
            self.value = v
        } else if let v = try? container.decode([AnyCodable].self) {
            self.value = v.map { $0.value }
        } else if let v = try? container.decode([String: AnyCodable].self) {
            self.value = v.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode AnyCodable")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let v as Bool:
            try container.encode(v)
        case let v as Int:
            try container.encode(v)
        case let v as Double:
            try container.encode(v)
        case let v as String:
            try container.encode(v)
        case let v as [Any]:
            let encodable = v.map { AnyCodable($0) }
            try container.encode(encodable)
        case let v as [String: Any]:
            let encodable = v.mapValues { AnyCodable($0) }
            try container.encode(encodable)
        default:
            let context = EncodingError.Context(codingPath: container.codingPath,
                                                debugDescription: "Unsupported AnyCodable type")
            throw EncodingError.invalidValue(value, context)
        }
    }
}
