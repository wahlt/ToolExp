//
//  SymbolicEngine.swift
//  ToolMath
//
//  1. Purpose
//     Simplified symbolic expression representation and manipulation.
// 2. Dependencies
//     Foundation
// 3. Overview
//     Defines `Expr` enum and basic simplifications.
// 4. Usage
//     `SymbolicEngine.simplify(.add(.var("x"), .zero))`
// 5. Notes
//     Not a full CAS—demo only.

import Foundation

public enum Expr: CustomStringConvertible {
    case variable(String)
    case constant(Float)
    case add(Expr, Expr)
    case mul(Expr, Expr)
    case pow(Expr, Float)

    public var description: String {
        switch self {
        case .variable(let v): return v
        case .constant(let c): return String(c)
        case .add(let a, let b): return "(\(a)+\(b))"
        case .mul(let a, let b): return "(\(a)*\(b))"
        case .pow(let a, let p): return "(\(a)^\(p))"
        }
    }
}

public final class SymbolicEngine {
    public init() {}

    /// Simplifies an expression by applying trivial rules.
    public func simplify(_ expr: Expr) -> Expr {
        switch expr {
        case .add(let a, let b):
            let sa = simplify(a), sb = simplify(b)
            // x+0 => x
            if case .constant(0) = sb { return sa }
            if case .constant(0) = sa { return sb }
            return .add(sa, sb)
        case .mul(let a, let b):
            let sa = simplify(a), sb = simplify(b)
            // x*1 => x, x*0 => 0
            if case .constant(1) = sb { return sa }
            if case .constant(1) = sa { return sb }
            if case .constant(0) = sb { return .constant(0) }
            if case .constant(0) = sa { return .constant(0) }
            return .mul(sa, sb)
        case .pow(let a, let p):
            let sa = simplify(a)
            // x^1 => x, x^0 => 1
            if p == 1 { return sa }
            if p == 0 { return .constant(1) }
            return .pow(sa, p)
        default:
            return expr
        }
    }
}
