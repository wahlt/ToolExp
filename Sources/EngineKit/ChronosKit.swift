//
//  ChronosKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ChronosKit.swift
// EngineKit — Kernel compiler & simulation runner.
//
// Responsibilities:
//
//  1. Compile custom compute kernels (Metal/MLX/CPU).
// 2. Provide unified API for stepping simulations.
// 3. Manage resource lifetime & multi‐device dispatch.
//

import Foundation

/// Error thrown during kernel compilation or execution.
public enum ChronosError: Error, LocalizedError {
    case compilationFailed(String)
    case executionFailed(String)

    public var errorDescription: String? {
        switch self {
        case .compilationFailed(let msg):
            return "Kernel compilation failed: \(msg)"
        case .executionFailed(let msg):
            return "Kernel execution failed: \(msg)"
        }
    }
}

/// Represents a compiled compute kernel.
public protocol CompiledKernel {
    /// Run the kernel with named input buffers & collect outputs.
    func run(inputs: [String: Any], outputs: inout [String: Any]) throws
}

/// Main ChronosKit facade.
public final class ChronosKit {
    public init() {}

    /// Compile source code (Metal/MLX DSL) into a `CompiledKernel`.
    public func compileKernel(source: String) throws -> CompiledKernel {
        // TODO:
        // 1. Detect if source is MLX DSL or raw Metal.
        // 2. Use MLXRenderer or MTLLibrary + function.
        // 3. Wrap into a CompiledKernel instance.
        throw ChronosError.compilationFailed("Not implemented")
    }

    /// Perform a single simulation step.
    ///
    /// - Parameters:
    ///   - kernel: the compiled kernel to run.
    ///   - inputs: named input data.
    ///   - outputs: storage for output data.
    /// - Throws: execution errors.
    public func step(
        kernel: CompiledKernel,
        inputs: [String: Any],
        outputs: inout [String: Any]
    ) throws {
        // TODO: forward to kernel.run
        try kernel.run(inputs: inputs, outputs: &outputs)
    }
}
