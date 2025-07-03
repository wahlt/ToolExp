//
//  TensorEngine.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TensorEngine.swift
//  ToolMath
//
//  1. Purpose
//     Orchestrates CPU vs GPU numeric backends.
// 2. Dependencies
//     EnginePrecisionService, DefaultNumericEngine, MLXIntegration
// 3. Overview
//     Delegates to MPSGraph or CPU based on precision setting.
// 4. Usage
//     `TensorEngine.shared.add(a,b)`
// 5. Notes
//     Listens for precision changes via NotificationCenter.

import Foundation
import MLXIntegration

public final class TensorEngine {
    public static let shared = TensorEngine()
    private let numeric = DefaultNumericEngine()
    private var precision: Precision

    private init() {
        precision = EnginePrecisionService.shared.currentPrecision
        NotificationCenter.default.addObserver(
            self, selector: #selector(didChangePrecision(_:)),
            name: .precisionModeDidChange, object: nil
        )
    }

    @objc private func didChangePrecision(_ note: Notification) {
        if let p = note.object as? Precision {
            precision = p
        }
    }

    /// Adds two MLXArrays or falls back to CPU arrays.
    public func add(_ a: MLXArray, _ b: MLXArray) throws -> MLXArray {
        // If precision==fp32 or higher and GPU available, use MPSGraph
        if precision != .fp16 {
            // use MLXArray JIT
            return a + b
        } else {
            // fallback
            let aArr = a.scalars; let bArr = b.scalars
            let out  = numeric.add(aArr,bArr)
            return try MLXArray.make(values: out, shape: a.shape.map{Int($0)}, precision: precision)
        }
    }
}
