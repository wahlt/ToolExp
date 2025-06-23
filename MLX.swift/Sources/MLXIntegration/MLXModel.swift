//
//  MLXModel.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// swift-tools-version:6.2
// MLXModel.swift
// MLXIntegration — Wraps a compiled CoreML model for GPU inference.

import Foundation
import CoreML

public final class MLXModel {
    private let mlModel: MLModel
    public let inputNames: [String]
    public let outputNames: [String]

    /// Load a compiled `.mlmodelc` at `modelURL`.
    public init(compiledModelURL: URL) throws {
        self.mlModel = try MLModel(contentsOf: compiledModelURL)
        let desc = mlModel.modelDescription
        self.inputNames = Array(desc.inputDescriptionsByName.keys)
        self.outputNames = Array(desc.outputDescriptionsByName.keys)
    }

    /// The underlying CoreML model (for advanced uses).
    internal var coreMLModel: MLModel { mlModel }
}
