//
//  TensorBridge.swift
//  IntegrationKit
//
//  Bridges RepStruct ↔ MLXArray for GPU/NPU-accelerated compute.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import RepKit
import MLX

public extension RepStruct {
    /// Previously attached MLXArray tensor, if any.
    var tensor: MLXArray? {
        get { metadata["tensor"] as? MLXArray }
        set { metadata["tensor"] = newValue }
    }

    /// Attaches a tensor to this RepStruct for later retrieval.
    mutating func attachTensor(_ tensor: MLXArray) {
        metadata["tensor"] = tensor
    }
}//
//  TensorBridge.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

