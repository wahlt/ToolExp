//
//  RepSerializer.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepSerializer.swift
// RepKit — JSON import/export for RepStruct.
//
// Relies on Codable synthesis of Cell and AnyCodable.
//

import Foundation

/// Errors during serialization or deserialization.
public enum SerializationError: Error, LocalizedError {
    case invalidJSONString
    case decodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidJSONString:
            return "Produced JSON string is invalid."
        case .decodingFailed(let err):
            return "Decoding failed: \(err)"
        }
    }
}

/// Converts `RepStruct` to/from JSON for interchange.
public struct RepSerializer {
    /// Encode a `RepStruct` to pretty‐printed JSON.
    public static func toJSON(_ rep: RepStruct) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(rep)
        guard let str = String(data: data, encoding: .utf8) else {
            throw SerializationError.invalidJSONString
        }
        return str
    }

    /// Decode a `RepStruct` from JSON.
    public static func fromJSON(_ json: String) throws -> RepStruct {
        let data = Data(json.utf8)
        do {
            return try JSONDecoder().decode(RepStruct.self, from: data)
        } catch {
            throw SerializationError.decodingFailed(error)
        }
    }
}
