//
//  FPKit.swift
//  ServiceKit
//
//  1. Purpose
//     Floating-point utilities (clamp, lerp, epsilon comparisons).
// 2. Dependencies
//     Foundation, simd
// 3. Overview
//     Provides global functions for reliable FP math.
// 4. Usage
//     let close = FPKit.approxEqual(a,b)
// 5. Notes
//     Epsilon can be tuned for application precision.

import Foundation
import simd

public enum FPKit {
    /// Linear interpolation
    public static func lerp(_ a: Float, _ b: Float, t: Float) -> Float {
        return a + (b - a) * t
    }

    /// Clamps value between min and max
    public static func clamp(_ v: Float, min: Float, max: Float) -> Float {
        return Swift.max(min, Swift.min(max, v))
    }

    /// Checks approximate equality within epsilon
    public static func approxEqual(
        _ a: Float, _ b: Float,
        epsilon: Float = 1e-5
    ) -> Bool {
        return abs(a - b) <= epsilon
    }
}
