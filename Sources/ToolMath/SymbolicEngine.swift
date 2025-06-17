//
//  SymbolicEngine.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// SymbolicEngine.swift
// ToolMath — Stub for symbolic math interface.
//
// Could wrap SymPy, Wolfram, or custom rewrite systems.
//

import Foundation

/// Protocol for a symbolic computation engine.
public protocol SymbolicEngine {
    /// Simplify the given expression.
    func simplify(_ expr: String) async throws -> String

    /// Differentiate the given expression w.r.t. `variable`.
    func differentiate(_ expr: String, withRespectTo variable: String) async throws -> String
}

/// A no-op symbolic engine returning input.
public struct DummySymbolicEngine: SymbolicEngine {
    public init() {}

    public func simplify(_ expr: String) async throws -> String {
        return expr
    }

    public func differentiate(_ expr: String, withRespectTo variable: String) async throws -> String {
        return "d(\(expr))/d\(variable)"
    }
}
