// File: Sources/DataServ/Port.swift
//  DataServ
//
//  Specification:
//  • Previously imported RepKit to alias or deprecate its `Port` type.
//  • Now decoupled: DataServ defines its own `Port` helper, or simply removes the import.
//
//  Discussion:
//  DataServ should not depend on RepKit.  We remove `import RepKit`
//  so that DataServ compiles standalone.  If you need a Port type,
//  define it here or alias it only after RepKit becomes a declared dependency.
//
//  Rationale:
//  • Prevents “no such module ‘RepKit’” errors in DataServ builds.
//  • Keeps DataServ a pure persistence-layer module.
//
//  TODO:
//  • If a `Port<T>` abstraction is required, implement it here.
//  • Add unit tests for any port behavior or serialization support.
//
//  Dependencies: Foundation
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Placeholder for a port abstraction in DataServ.
/// Remove or expand this as needed when integrating with RepKit.
public struct Port<T: Codable>: Codable {
    public let key: String
    public let value: T

    public init(key: String, value: T) {
        self.key = key
        self.value = value
    }
}
