//
//  GPUFilterService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  GPUFilterService.swift
//  UXKit
//
//  1. Purpose
//     Applies real-time image filters (blur, sharpen) via Metal compute.
// 2. Dependencies
//     MetalKit, Combine
// 3. Overview
//     Builds or reuses MTLComputePipelineStates for each filter kernel.
// 4. Usage
//     `GPUFilterService.shared.apply(.gaussian, to: texture)`
// 5. Notes
//     Exposes publisher-based API for chaining filters.

import MetalKit
import Combine

public enum ImageFilter {
    case gaussian(sigma: Float)
    case sharpen(amount: Float)
}

public final class GPUFilterService {
    public static let shared = GPUFilterService()
    private let device: MTLDevice
    private let queue: MTLCommandQueue
    private var pipelines: [String: MTLComputePipelineState] = [:]

    private init() {
        guard let dev = MTLCreateSystemDefaultDevice() else {
            fatalError("GPUFilterService requires Metal support")
        }
        device = dev
        queue  = dev.makeCommandQueue()!
    }

    /// Applies the given filter to `input`, writes result into `output`.
    public func apply(
        _ filter: ImageFilter,
        to input: MTLTexture,
        output: MTLTexture
    ) -> AnyPublisher<MTLTexture, Never> {
        Future { promise in
            let kernelName: String
            let params: [Float]
            switch filter {
            case .gaussian(let sigma):
                kernelName = "gaussianBlur"
                params = [sigma]
            case .sharpen(let amt):
                kernelName = "sharpen"
                params = [amt]
            }

            // compile or fetch pipeline
            let pipeline: MTLComputePipelineState
            if let p = self.pipelines[kernelName] {
                pipeline = p
            } else {
                let lib = self.device.makeDefaultLibrary()!
                let fn  = lib.makeFunction(name: kernelName)!
                pipeline = try! self.device.makeComputePipelineState(function: fn)
                self.pipelines[kernelName] = pipeline
            }

            // encode compute pass
            let cmd = self.queue.makeCommandBuffer()!
            let enc = cmd.makeComputeCommandEncoder()!
            enc.setComputePipelineState(pipeline)
            enc.setTexture(input, index: 0)
            enc.setTexture(output, index: 1)
            var p = params
            enc.setBytes(&p, length: MemoryLayout<Float>.stride * p.count, index: 0)
            let w = MTLSize(width: input.width, height: input.height, depth: 1)
            let tg = MTLSize(width: pipeline.threadExecutionWidth,
                             height: pipeline.maxTotalThreadsPerThreadgroup / pipeline.threadExecutionWidth,
                             depth: 1)
            enc.dispatchThreads(w, threadsPerThreadgroup: tg)
            enc.endEncoding()
            cmd.addCompletedHandler { _ in promise(.success(output)) }
            cmd.commit()
        }
        .eraseToAnyPublisher()
    }
}
