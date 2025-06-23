//
//  StatsKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  StatsKit.swift
//  ToolMath
//
//  Specification:
//  • Basic statistical routines: mean, variance, histogram.
//  • Supports normal distribution PDF and sampling.
//
//  Discussion:
//  Useful for evaluating datasets generated in mathResearch stage.
//
//  Rationale:
//  • Simplify exploratory data analysis in‐app.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum StatsKit {
    /// Computes the mean of an array of Doubles.
    public static func mean(_ xs: [Double]) -> Double {
        guard !xs.isEmpty else { return 0 }
        return xs.reduce(0, +) / Double(xs.count)
    }

    /// Computes the variance of an array of Doubles.
    public static func variance(_ xs: [Double]) -> Double {
        let m = mean(xs)
        return xs.map { ($0 - m)*($0 - m) }.reduce(0, +) / Double(xs.count)
    }

    /// Normal distribution PDF at x.
    public static func normalPDF(x: Double, mean μ: Double, sigma σ: Double) -> Double {
        let coeff = 1.0 / (σ * sqrt(2 * .pi))
        let exponent = -((x - μ)*(x - μ)) / (2*σ*σ)
        return coeff * exp(exponent)
    }
}
