//
//  MLXRenderer.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// MLXRenderer.swift
// MLXIntegration — Metal 4 + ML command‐encoder integration.
// Leverages MLX Swift API, MPSGraph, mesh shaders, and MetalFX.
//

import MetalKit
import MLX
import MetalPerformanceShadersGraph

/// Renders with a combination of standard and ML-accelerated passes.
public final class MLXRenderer: NSObject, MTKViewDelegate {
    private let device: MTLDevice
    private let queue: MTLCommandQueue
    private let mlContext: MLContext
    private let graph: MPSGraph

    public init?(mtkView: MTKView) {
        guard let dev = MTLCreateSystemDefaultDevice(),
              let q = dev.makeCommandQueue() else {
            return nil
        }
        device = dev
        queue = q
        mlContext = MLContext(device: dev)
        graph = MPSGraph()
        super.init()
        mtkView.device = dev
        mtkView.delegate = self
    }

    public func draw(in view: MTKView) {
        guard let desc = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else { return }

        #if DEBUG
        MTLCaptureManager.shared().startCapture(device: device)
        #endif

        let cb = queue.makeCommandBuffer()!

        // ————— MLX Pass —————
        let tensorA = mlContext.tensor([1.0, 2.0, 3.0])
        let result = mlContext.matmul(tensorA, tensorA)
        mlContext.encodeGraph(
            graph,
            to: cb,
            inputs: ["input": tensorA],
            results: ["output": result]
        )

        // ————— Mesh Shader Pass —————
        // TODO: set up MTLMeshDescriptor & dispatch via new pipeline

        // ————— MetalFX Denoise & Upscale —————
        if let denoiser = MPSImageDenoise(device: device) {
            denoiser.encode(
                commandBuffer: cb,
                sourceTexture: drawable.texture,
                destinationTexture: drawable.texture
            )
        }

        cb.present(drawable)
        cb.commit()

        #if DEBUG
        MTLCaptureManager.shared().stopCapture()
        #endif
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle resize if needed
    }
}
