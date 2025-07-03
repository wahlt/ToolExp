//
//  MLXModel.swift
//  MLXIntegration
//
//  Loads and runs Core ML models, converting to/from MLXArray.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import CoreML
import MLX

public final class MLXModel {
    private let model: MLModel

    /// Loads a `.mlmodelc` at `url`.
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Performs a prediction given a single-array input.
    /// - Parameters:
    ///   - input: MLXArray of shape matching the model’s input.
    ///   - inputName: Name of the model’s input in the MLModel spec.
    ///   - outputName: Name of the desired output in the spec.
    /// - Returns: Output as MLXArray.
    public func predict(
        input: MLXArray,
        inputName: String,
        outputName: String
    ) throws -> MLXArray {
        // Convert MLXArray → MLMultiArray
        let multi = try input.toMultiArray()
        let provider = try MLDictionaryFeatureProvider(dictionary: [inputName: multi])
        let out = try model.prediction(from: provider)
        guard let resultMulti = out.featureValue(for: outputName)?.multiArrayValue else {
            fatalError("MLXModel: missing output \(outputName)")
        }
        return try MLXArray(multiArray: resultMulti)
    }
}
