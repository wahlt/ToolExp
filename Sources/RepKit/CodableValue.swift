//
//  CodableValue.swift
//  RepKit
//
//  1. Purpose
//     Legacy alias wrapper around `AnyCodable`.
// 2. Dependencies
//     AnyCodable
// 3. Overview
//     Allows using `AnyCodable` under a unified name.
// 4. Usage
//     `let v: CodableValue = .init(someJSON)`
// 5. Notes
//     Will be removed once all code migrates.

import AnyCodable

/// Type-alias for compatibility with older code.
public typealias CodableValue = AnyCodable

extension CodableValue {
    /// Initialize from any JSON-compatible value.
    public init(_ value: Any) {
        self = AnyCodable(value)
    }
}
