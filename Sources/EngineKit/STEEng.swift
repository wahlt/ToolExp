//
//  STEEng.swift
//  EngineKit
//
//  Specification:
//  • Simplified STEM engine: solves small linear systems & PDE stubs.
//  • Provides APIs for algebraic operations in RepKit.
//
//  Discussion:
//  Full tensor solves live in RepKit; STEEng offers quick CPU prototypes.
//
//  Rationale:
//  • Light-weight for rapid “what-if” approximations.
//  • Replaceable with full tensor-network solves later.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum STEEng {
    /// Solves A·x = b for small dense A via Gaussian elimination.
    public static func solveLinear(A: [[Double]], b: [Double]) -> [Double]? {
        let n = b.count
        var M = A, y = b
        for i in 0..<n {
            let pivot = M[i][i]
            guard pivot != 0 else { return nil }
            for j in i..<n { M[i][j] /= pivot }
            y[i] /= pivot
            for k in (i+1)..<n {
                let factor = M[k][i]
                for j in i..<n {
                    M[k][j] -= factor * M[i][j]
                }
                y[k] -= factor * y[i]
            }
        }
        var x = Array(repeating: 0.0, count: n)
        for i in stride(from: n-1, through: 0, by: -1) {
            var sum = y[i]
            for j in (i+1)..<n {
                sum -= M[i][j] * x[j]
            }
            x[i] = sum
        }
        return x
    }

    /// Placeholder PDE solver: returns zeros.
    public static func solveHeat1D(length: Int, timeStep: Double) -> [Double] {
        return Array(repeating: 0.0, count: length)
    }
}
