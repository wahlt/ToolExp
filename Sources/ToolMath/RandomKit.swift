//
//  RandomKit.swift
//  ToolMath
//
//  1. Purpose
//     Random number and distribution utilities.
// 2. Dependencies
//     Foundation, GameplayKit
// 3. Overview
//     Provides uniform, normal, and seedable RNG.
// 4. Usage
//     `RandomKit.normal(mean:0, sigma:1, count:100)`
// 5. Notes
//     Uses SystemRandom by default.

import Foundation
import GameplayKit

public enum RandomKit {
    private static var rng = GKMersenneTwisterRandomSource()

    public static func uniform(count: Int, in range: ClosedRange<Float>) -> [Float] {
        return (0..<count).map { _ in
            Float(rng.nextUniform())*(range.upperBound - range.lowerBound) + range.lowerBound
        }
    }

    public static func normal(mean: Float, sigma: Float, count: Int) -> [Float] {
        let dist = GKGaussianDistribution(randomSource: rng, mean: 0, deviation: Int(sigma*100))
        return (0..<count).map { _ in Float(dist.nextInt())/100 + mean }
    }

    public static func reseed(with seed: UInt64) {
        rng = GKMersenneTwisterRandomSource(seed: seed)
    }
}
