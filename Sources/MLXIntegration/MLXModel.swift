// File: Sources/MLXIntegration/MLXModel.swift
//
//  MLXModel.swift
//  MLXIntegration
//
//  Specification:
//  • Wraps a compiled CoreML model for GPU inference.
//  • Exposes input/output feature names.
//
//  Discussion:
//  Loads a `.mlmodelc` bundle, extracts its model description,
//  and provides the underlying MLModel for advanced usage.
//
//  Rationale:
//  • Separates model-loading from inference and UI code.
//  • Metadata enables dynamic binding of textures and buffers.
//
//  Dependencies: Foundation, CoreML
//  Created by Thomas Wahl on 06/17/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import CoreML

public final class MLXModel {
    private let mlModel: MLModel
    public let inputNames: [String]
    public let outputNames: [String]

    /// Initialize by loading a compiled `.mlmodelc` bundle.
    public init(compiledModelURL: URL) throws {
        let model = try MLModel(contentsOf: compiledModelURL)
        self.mlModel     = model
        let desc         = model.modelDescription
        self.inputNames  = Array(desc.inputDescriptionsByName.keys)
        self.outputNames = Array(desc.outputDescriptionsByName.keys)
    }

    /// Direct access to the underlying CoreML model.
    public var coreMLModel: MLModel {
        return mlModel
    }
}
