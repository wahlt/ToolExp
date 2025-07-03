//
//  PDESolver.swift
//  ToolMath
//
//  1. Purpose
//     CPU fallback PDE solvers (heat, wave) for 1D.
// 2. Dependencies
//     Foundation
// 3. Overview
//     Implements explicit finite-difference schemes.
// 4. Usage
//     `PDESolver.solveHeat(u0, alpha:0.1, dt:0.01, steps:100)`
// 5. Notes
//     For small grids or testing when GPU not desired.

import Foundation

public enum PDESolver {
    public static func solveHeat1D(
        u0: [Float], alpha: Float, dx: Float, dt: Float, steps: Int
    ) -> [Float] {
        let n = u0.count
        var u = u0, uNew = u0
        let r = alpha * dt / (dx*dx)
        for _ in 0..<steps {
            for i in 1..<n-1 {
                uNew[i] = u[i] + r*(u[i+1] - 2*u[i] + u[i-1])
            }
            u = uNew
        }
        return u
    }

    public static func solveWave1D(
        u0: [Float], v0: [Float], c: Float, dx: Float, dt: Float, steps: Int
    ) -> [Float] {
        let n = u0.count
        var uPrev = u0
        var uCurr = zip(u0, v0).map { u0_i, v0_i in
            u0_i + v0_i*dt + 0.5*(c*c*dt*dt/dx/dx) *
                ((u0_i != u0.last ? u0_i : 0) - 2*u0_i + (u0_i != u0.first ? u0_i : 0))
        }
        var uNext = [Float](repeating: 0, count: n)
        for _ in 2...steps {
            for i in 1..<n-1 {
                uNext[i] = 2*uCurr[i] - uPrev[i] +
                    (c*c*dt*dt/dx/dx)*(uCurr[i+1] - 2*uCurr[i] + uCurr[i-1])
            }
            uPrev = uCurr
            uCurr = uNext
        }
        return uCurr
    }
}
