//
//  RandomKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RandomKit.swift
// ToolMath — Random number utilities and distributions.
//

import Foundation

/// Seeded random number generator.
public struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    public init(seed: UInt64) {
        self.state = seed
    }

    public mutating func next() -> UInt64 {
        // Xorshift64* algorithm
        state ^= state >> 12
        state ^= state << 25
        state ^= state >> 27
        return state &* 2685821657736338717
    }
}

/// Utility functions for random sampling.
public enum RandomKit {
    /// Sample a uniform Double in [0,1).
    public static func uniform01<G: RandomNumberGenerator>(using rng: inout G) -> Double {
        return Double(rng.next() & 0xFFFFFFFF) / Double(UInt32.max)
    }
}
