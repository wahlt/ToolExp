//
//  RepSerializer.swift
//  RepKit
//
//  Specification:
//  • Serializes RepStruct data to/from JSON Data.
//  • Uses JSONEncoder/Decoder with pretty‐print.
//
//  Discussion:
//  Useful for export/import, network sync, and persistence.
//
//  Rationale:
//  • Standard JSON pipeline guarantees interoperability.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum RepSerializer {
    public static func toJSON(_ rep: RepStruct) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(rep)
    }

    public static func fromJSON(_ data: Data) throws -> RepStruct {
        return try JSONDecoder().decode(RepStruct.self, from: data)
    }
}
