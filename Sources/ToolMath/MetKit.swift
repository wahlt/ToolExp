//
//  MetKit.swift
//  ToolMath
//
//  1. Purpose
//     Statistical and metric computations.
// 2. Dependencies
//     Foundation, Statistics
// 3. Overview
//     Provides mean, variance, norms, distances.
// 4. Usage
//     `MetKit.euclideanNorm(vector)`
// 5. Notes
//     Numeric engine–agnostic.

import Foundation
import Accelerate

public enum MetKit {
    public static func euclideanNorm(_ v: [Float]) -> Float {
        var result: Float = 0
        vDSP_svesq(v, 1, &result, vDSP_Length(v.count))
        return sqrt(result)
    }

    public static func manhattanNorm(_ v: [Float]) -> Float {
        return v.reduce(0) { $0 + abs($1) }
    }

    public static func variance(_ v: [Float]) -> Float {
        var mean: Float = 0
        vDSP_meanv(v, 1, &mean, vDSP_Length(v.count))
        var varOut: Float = 0
        vDSP_measqv(v, 1, &varOut, vDSP_Length(v.count))
        return varOut - mean*mean
    }
}
