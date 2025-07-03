//
//  MatKit.swift
//  ToolMath
//
//  1. Purpose
//     CPU-based matrix and tensor utilities.
// 2. Dependencies
//     Foundation
// 3. Overview
//     Offers basic operations: transpose, inverse, determinant for small matrices.
// 4. Usage
//     `MatKit.inverse(matrix)`
// 5. Notes
//     Fallback for non-GPU paths; uses Accelerate when available.

import Foundation
import Accelerate

public enum MatKit {
    /// Transpose a flat row-major matrix of size NxM.
    public static func transpose(_ a: [Float], rows: Int, cols: Int) -> [Float] {
        precondition(a.count == rows*cols)
        var out = [Float](repeating:0, count:a.count)
        vDSP_mtrans(a, 1, &out, 1, vDSP_Length(cols), vDSP_Length(rows))
        return out
    }

    /// Computes inverse of a square matrix.
    public static func inverse(_ a: [Float], dimension n: Int) -> [Float]? {
        var inMat = a
        var N = __CLPK_integer(n)
        var pivots = [__CLPK_integer](repeating: 0, count: n)
        var workspace = [Float](repeating:0, count: n)
        var error: __CLPK_integer = 0
        sgetrf_(&N, &N, &inMat, &N, &pivots, &error)
        guard error == 0 else { return nil }
        sgetri_(&N, &inMat, &N, &pivots, &workspace, &N, &error)
        return error == 0 ? inMat : nil
    }
}
