//
//  MLXTensor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// MLXTensor.swift
// MLXIntegration — Represents a tensor as a Metal texture.

import Metal

public struct MLXTensor {
    public let texture: MTLTexture
    public let shape: [Int]

    /// Wrap an existing MTLTexture as a tensor.
    public init(texture: MTLTexture, shape: [Int]) {
        self.texture = texture
        self.shape = shape
    }

    /// Allocate a new 1D or 2D tensor on `device`.
    public init(
        device: MTLDevice,
        shape: [Int],
        pixelFormat: MTLPixelFormat = .r32Float,
        usage: MTLTextureUsage = [.shaderRead, .shaderWrite]
    ) {
        self.shape = shape
        let desc = MTLTextureDescriptor()
        desc.pixelFormat = pixelFormat
        desc.usage = usage

        // Support 1D (shape = [N]) or 2D ([W, H])
        desc.width = shape[0]
        desc.height = shape.count > 1 ? shape[1] : 1

        guard let tex = device.makeTexture(descriptor: desc) else {
            fatalError("MLXTensor: failed to create texture for shape \(shape)")
        }
        self.texture = tex
    }
}
