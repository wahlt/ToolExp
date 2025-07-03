//
//  MLXRenderer.swift
//  MLXIntegration
//
//  Renders float-based MLXArray image tensors into MTLTextures.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Metal
import MetalKit
import MLX

public final class MLXRenderer {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    public init(
        device: MTLDevice = MLXCommandQueue.shared.device,
        queue: MTLCommandQueue = MLXCommandQueue.shared.queue
    ) {
        self.device = device
        self.commandQueue = queue
    }

    /// Takes an MLXArray of shape [C,H,W] or [H,W] and writes it into a new texture.
    public func makeTexture(from tensor: MLXArray) throws -> MTLTexture {
        let shape = tensor.shape.map { $0.intValue }
        let height = shape.count >= 2 ? shape[shape.count - 2] : 1
        let width  = shape.count >= 1 ? shape[shape.count - 1] : 1
        let desc = MTLTextureDescriptor()
        desc.pixelFormat = .r32Float
        desc.width  = width
        desc.height = height
        desc.usage  = [.shaderRead, .shaderWrite]
        guard let tex = device.makeTexture(descriptor: desc) else {
            fatalError("MLXRenderer: failed to create texture")
        }
        // Copy raw scalars
        let scalars = tensor.scalars
        let bytesPerRow = width * MemoryLayout<Float>.size
        tex.replace(
            region: MTLRegionMake2D(0, 0, width, height),
            mipmapLevel: 0,
            withBytes: scalars,
            bytesPerRow: bytesPerRow
        )
        return tex
    }
}
