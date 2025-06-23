//
//  PDESolver.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// PDESolver.swift
// ToolMath — Stub for PDE solver actor.
//
// Could be implemented via MPSGraph or custom Rust/Julia kernels.
//

import Foundation

/// Parameters for a simple diffusion PDE.
public struct DiffusionParams {
    public var rate: Double
    public init(rate: Double = 1.0) {
        self.rate = rate
    }
}

/// Protocol for PDE solvers.
public protocol PDESolver {
    /// Solve ∂u/∂t = L[u] over a grid.
    /// - `grid`: flattened grid values row-major.
    /// - `width`, `height`: grid dimensions.
    /// - `dt`: time step.
    func step(grid: [Double], width: Int, height: Int, dt: Double) -> [Double]
}

/// A trivial Euler‐forward diffusion solver.
public struct EulerDiffusionSolver: PDESolver {
    public let params: DiffusionParams

    public init(params: DiffusionParams = .init()) {
        self.params = params
    }

    public func step(grid: [Double], width: Int, height: Int, dt: Double) -> [Double] {
        // TODO: implement Laplacian stencil by neighbor sums.
        return grid
    }
}
