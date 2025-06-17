//
//  RepRenderer.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepRenderer.swift
// RenderKit — Transforms `RepStruct` into GPU buffers.
//
// Responsibilities:
//  • Flatten cell meshes, transforms, and trait tensors.
//  • Create Metal buffers for vertex, index, and trait data.
//  • Provide binding indices for all pipelines (basic, ultra, SFX).
//

import Foundation
import MetalKit
import RepKit

public final class RepRenderer {
    private let device: MTLDevice

    public init(device: MTLDevice) {
        self.device = device
    }

    /// Uploads all Rep data to GPU buffers.
    /// - Returns: a struct of `MTLBuffer`s for vertices, indices, transforms.
    public func uploadBuffers(for rep: RepStruct) -> (vertex: MTLBuffer, index: MTLBuffer, transform: MTLBuffer) {
        // 1) Iterate rep.cells → collect mesh vertices & indices
        // 2) Lay out in contiguous arrays
        // 3) Create `device.makeBuffer(bytes:length:options:)`
        // 4) Return a tuple of buffers
        fatalError("TODO: implement uploadBuffers")
    }
}
