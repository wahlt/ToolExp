//
//  ArtEngine.swift
//  RenderKit
//
//  Created by Thomas Wahl on 6/16/25.
//
// ArtEngine.swift
// Responsible for GPU-based procedural generation of art assets
// using Metal compute shaders.
//

import Foundation
import Metal
import CoreGraphics

/// Singleton wrapper for Metal-based rendering.
public final class ArtEngine {
    private let device: MTLDevice
    private let queue: MTLCommandQueue

    public init(device: MTLDevice) {
        self.device = device
        self.queue  = device.makeCommandQueue()!
    }

    /// Generate an image of the given size via a compute kernel.
    public func generate(size: CGSize) async throws -> MTLTexture {
        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: Int(size.width),
            height: Int(size.height),
            mipmapped: false
        )
        let texture = device.makeTexture(descriptor: desc)!

        let cmdBuf = queue.makeCommandBuffer()!
        // TODO: dispatch compute kernel writing into `texture`

        cmdBuf.commit()
        // replace the old `waitUntilCompleted()` call with async-friendly API:
        await cmdBuf.completed()
        return texture
    }
}
