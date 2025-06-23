//
//  MLXGraph.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// MLXGraph.swift
// MLXIntegration — Encapsulates an ML inference pass using compute encoders.

import Metal

public final class MLXGraph {
    private let model: MLXModel

    /// Wrap a compiled MLXModel for “inference.”
    public init(model: MLXModel) {
        self.model = model
    }

    /// Encode inference on `encoder`, consuming `inputs` and writing to `outputs`.
    /// Currently a stub: real code would bind textures/buffers and dispatch.
    public func encodeInference(
        on encoder: MTLComputeCommandEncoder,
        inputs: [MLXTensor],
        outputs: [MLXTensor]
    ) {
        // Stub: in a production version you'd:
        // 1. encoder.setBuffer/texture for each input
        // 2. encoder.setBuffer/texture for each output
        // 3. encoder.dispatchThreadgroups(...) for your ML kernel
        encoder.endEncoding()
    }
}
