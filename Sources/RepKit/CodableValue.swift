//
//  CodableValue.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  CodableValue.swift
//  RepKit
//
//  Specification:
//  • Wrapper for heterogenous Codable `value` + `type` metadata.
//  • Enables round‐trip encoding of dynamic fields.
//
//  Discussion:
//  Some Rep fields require preserving original type info
//  (e.g. Int vs. Double) beyond JSON’s loose rules.
//
//  Rationale:
//  • Store type identifier alongside raw JSON value.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct CodableValue: Codable, Equatable {
    public let typeName: String
    public let rawValue: Data

    public init<T: Codable>(_ value: T) throws {
        self.typeName = String(describing: T.self)
        self.rawValue = try JSONEncoder().encode(value)
    }

    public func decode<T: Codable>(as type: T.Type) throws -> T {
        return try JSONDecoder().decode(T.self, from: rawValue)
    }
}
