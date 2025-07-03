//
//  RenderAdapter.swift
//  RenderKit
//
//  1. Purpose
//     Adapts abstract scene/rep data into concrete GPU feeds.
// 2. Dependencies
//     Foundation, simd, MLXIntegration, MetalPerformanceShadersGraph, RepKit
// 3. Overview
//     Defines Mesh, Light, Camera, Scene types and packers,
//     plus a `toGraphFeeds()` that produces the
//     `[MPSGraphTensor: MPSGraphTensorData]` needed by MPSGraph pipelines.
// 4. Usage
//     Pass a `Scene` into DifferentiableRenderer or RendUltraEng.
// 5. Notes
//     Expand with environment maps, materials, etc.

import Foundation
import simd
import RepKit
import MLXIntegration
import MetalPerformanceShadersGraph

/// Geometry mesh with positions and normals.
public struct Mesh {
    public var vertices: [SIMD3<Float>]
    public var normals:  [SIMD3<Float>]
    public var indices:  [UInt32]

    public init(
        vertices: [SIMD3<Float>],
        normals:  [SIMD3<Float>],
        indices:  [UInt32]
    ) {
        self.vertices = vertices
        self.normals  = normals
        self.indices  = indices
    }
}

/// Point or area light.
public struct Light {
    public var position: SIMD3<Float>
    public var color:    SIMD3<Float>
    public var intensity: Float

    public init(
        position: SIMD3<Float>,
        color:    SIMD3<Float>,
        intensity: Float
    ) {
        self.position  = position
        self.color     = color
        self.intensity = intensity
    }
}

/// Camera with view and projection matrices.
public struct Camera {
    public var viewMatrix:       simd_float4x4
    public var projectionMatrix: simd_float4x4

    public init(
        viewMatrix:       simd_float4x4,
        projectionMatrix: simd_float4x4
    ) {
        self.viewMatrix       = viewMatrix
        self.projectionMatrix = projectionMatrix
    }
}

/// Complete scene description for rendering.
public struct Scene {
    public var meshes: [Mesh]
    public var lights: [Light]
    public var camera: Camera

    public init(meshes: [Mesh], lights: [Light], camera: Camera) {
        self.meshes = meshes
        self.lights = lights
        self.camera = camera
    }

    /// Number of mesh primitives.
    public var meshCount: Int { meshes.count }
    /// Number of lights.
    public var lightCount: Int { lights.count }

    /// Packs scene data into graph feeds for tensor pipelines.
    public func toGraphFeeds() throws -> [MPSGraphTensor: MPSGraphTensorData] {
        var feeds: [MPSGraphTensor: MPSGraphTensorData] = [:]

        // 1) Pack vertex & normal tensors
        let posNormals = try GeometryTensorService()
            .pack(meshes: meshes)
        let posData = try posNormals.positions.toMPSGraphTensorData()
        let norData = try posNormals.normals.toMPSGraphTensorData()

        // 2) Pack camera matrices as flat MLXArray
        let vm = camera.viewMatrix
        let pm = camera.projectionMatrix
        let vmFlat = [vm.columns.0, vm.columns.1, vm.columns.2, vm.columns.3]
            .flatMap { [$0.x,$0.y,$0.z,$0.w] }
        let pmFlat = [pm.columns.0, pm.columns.1, pm.columns.2, pm.columns.3]
            .flatMap { [$0.x,$0.y,$0.z,$0.w] }
        let vmArr = try MLXArray.make(values: vmFlat, shape: [4,4], precision: .fp32)
        let pmArr = try MLXArray.make(values: pmFlat, shape: [4,4], precision: .fp32)
        let vmData = try vmArr.toMPSGraphTensorData()
        let pmData = try pmArr.toMPSGraphTensorData()

        // 3) Pack lights into flat arrays
        let lightPos = lights.flatMap { [$0.position.x,$0.position.y,$0.position.z] }
        let lightCol = lights.flatMap { [$0.color.x,$0.color.y,$0.color.z] }
        let lightInt = lights.map { $0.intensity }

        let lpArr = try MLXArray.make(values: lightPos, shape: [lights.count,3], precision: .fp32)
        let lcArr = try MLXArray.make(values: lightCol, shape: [lights.count,3], precision: .fp32)
        let liArr = try MLXArray.make(values: lightInt, shape: [lights.count], precision: .fp32)

        let lpData = try lpArr.toMPSGraphTensorData()
        let lcData = try lcArr.toMPSGraphTensorData()
        let liData = try liArr.toMPSGraphTensorData()

        // 4) Retrieve the graph placeholders from a known registry
        let registry = TensorGraphRegistry.shared
        let (_, posPH, norPH, _) = registry.matrixMulGraph(rows: meshes.count, cols: 3)
        let (_, vmPH, _, _)   = registry.matrixMulGraph(rows: 4, cols: 4)
        let (_, lpPH, _, _)   = registry.identityGraph(length: lights.count * 3)
        let (_, lcPH, _, _)   = registry.identityGraph(length: lights.count * 3)
        let (_, liPH, _)      = registry.identityGraph(length: lights.count)

        // 5) Assemble feeds
        feeds[posPH] = posData
        feeds[norPH] = norData
        feeds[vmPH]  = vmData
        feeds[vmPH]  = pmData
        feeds[lpPH]  = lpData
        feeds[lcPH]  = lcData
        feeds[liPH]  = liData

        return feeds
    }
}
