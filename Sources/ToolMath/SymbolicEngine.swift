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

import Foundation

public protocol SymbolicEngine {
    func simplify(_ expr: String) async throws -> String
    func differentiate(_ expr: String, withRespectTo variable: String) async throws -> String
}

public @MainActor
struct DummySymbolicEngine: SymbolicEngine {
    public init() {}

    public func simplify(_ expr: String) async throws -> String {
        return expr
    }

    public func differentiate(_ expr: String, withRespectTo variable: String) async throws -> String {
        return "d(\(expr))/d\(variable)"
    }
}
