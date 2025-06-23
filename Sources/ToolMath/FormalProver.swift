//
//  FormalProver.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// FormalProver.swift
// ToolMath — Stub for a formal theorem-proving engine.
//

import Foundation

/// Represents a logical proposition.
public @MainActor
struct Proposition {
    public let description: String
}

/// Protocol for a formal logical prover.
public protocol FormalProver {
    func prove(_ prop: Proposition) async throws -> Bool
}

/// A no-op prover that always returns false.
public struct DummyProver: FormalProver {
    public init() {}
    public func prove(_ prop: Proposition) async throws -> Bool {
        return false
    }
}
