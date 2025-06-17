//
//  ComputerFallback.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ComputeFallback.swift
// EngineKit — CPU fallback implementations for GPU kernels.
//
// Responsibilities:
//
//  1. Provide pure-Swift versions of performance-critical kernels.
//  2. Automatically chosen when GPU is unavailable or for debugging.
//  3. Ensure numerical parity with Metal kernels.
//

import Foundation

/// Protocol for a CPU fallback of a named kernel.
public protocol ComputeFallback {
    /// Execute the fallback on CPU.
    /// - Parameters:
    ///   - inputs: named inputs (buffers, scalars).
    ///   - outputs: named outputs (mutated by reference).
    func executeCPU(
        inputs: [String: Any],
        outputs: inout [String: Any]
    ) throws
}

/// Registry to register & invoke fallbacks by name.
public struct FallbackRegistry {
    private static var registry: [String: ComputeFallback] = [:]

    /// Register a fallback for `kernelName`.
    public static func register(
        kernelName: String,
        fallback: ComputeFallback
    ) {
        registry[kernelName] = fallback
    }

    /// Run the fallback for `kernelName`.
    public static func run(
        kernelName: String,
        inputs: [String: Any],
        outputs: inout [String: Any]
    ) throws {
        guard let fb = registry[kernelName] else {
            throw NSError(domain: "ComputeFallback", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "No fallback for \(kernelName)"
            ])
        }
        try fb.executeCPU(inputs: inputs, outputs: &outputs)
    }
}
