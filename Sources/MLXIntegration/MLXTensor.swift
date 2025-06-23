// File: Sources/MLXIntegration/MLXTensor.swift
//
//  MLXTensor.swift
//  MLXIntegration
//
//  Specification:
//  • Represents a tensor as a Metal texture, supporting 1D & 2D shapes.
//
//  Discussion:
//  Wraps MTLTexture with shape metadata so ML kernels can bind
//  and process GPU data without additional bookkeeping.
//
//  Rationale:
//  • Simplifies ML pipeline code by pairing texture & dimension info.
//  • Supports flexible tensor shapes for varied model requirements.
//
//  Dependencies: Foundation, Metal
//  Created by Thomas Wahl on 06/17/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Metal

public struct MLXTensor {
    public let texture: MTLTexture
    public let shape: [Int]

    /// Wrap an existing Metal texture as a tensor.
    public init(texture: MTLTexture, shape: [Int]) {
        self.texture = texture
        self.shape   = shape
    }

    /// Allocate a new tensor on `device` with given shape.
    public init(
        device: MTLDevice,
        shape: [Int],
        pixelFormat: MTLPixelFormat = .r32Float,
        usage: MTLTextureUsage      = [.shaderRead, .shaderWrite]
    ) {
        self.shape = shape
        let desc  = MTLTextureDescriptor()
        desc.pixelFormat = pixelFormat
        desc.usage       = usage
        desc.width  = shape[0]
        desc.height = shape.count > 1 ? shape[1] : 1

        guard let tex = device.makeTexture(descriptor: desc) else {
            fatalError("MLXTensor: failed to create texture for shape \(shape)")
        }
        self.texture = tex
    }
}
