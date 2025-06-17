//
//  Evaluate.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Evaluate.swift
// InvestigateKit — Evaluate facet APIs, run queries against Reps.
//
// Responsibilities:
//
//  1. Parse user queries or DSL expressions.
//  2. Execute queries (counts, filters, aggregations).
//  3. Return typed results for UI or further analysis.
//

import Foundation
import RepKit

public enum EvaluationResult {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    case list([EvaluationResult])
    case error(String)
}

public struct Evaluate {
    /// Evaluate a query string against `rep`.
    ///
    /// - Parameter query: custom DSL or predicate.
    /// - Parameter rep: the `RepStruct` to query.
    /// - Returns: an `EvaluationResult`.
    public static func run(_ query: String, on rep: RepStruct) -> EvaluationResult {
        // TODO:
        // 1. Tokenize query (e.g. "count cells where trait.x > 0.5").
//      2. Traverse rep, apply predicate, aggregate data.
//      3. Return structured result.
        return .error("Not implemented")
    }
}
