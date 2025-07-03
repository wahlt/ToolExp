//
//  RepRenderer.swift
//  RenderKit
//
//  1. Purpose
//     Converts RepStruct into a Scene for rendering.
// 2. Dependencies
//     RepKit, RenderAdapter
// 3. Overview
//     Extracts mesh-like cells and light-like cells, builds a Scene.
// 4. Usage
//     Call `scene(from:)` prior to passing to Renderer.
// 5. Notes
//     Assumes rep metadata tags “mesh” and “light” on cells.

import Foundation
import RepKit

public final class RepRenderer {
    public init() {}

    /// Builds a Scene from a RepStruct.
    public func scene(from rep: RepStruct) throws -> Scene {
        var meshes: [Mesh] = []
        var lights: [Light] = []
        var camera: Camera = Camera(
            viewMatrix: .init(1),
            projectionMatrix: .init(1)
        )

        for cell in rep.cells {
            if let type = cell.metadata["type"]?.value as? String {
                switch type {
                case "mesh":
                    // Expect vertices/normals stored in metadata
                    let verts = cell.metadata["vertices"]?.value as? [Float] ?? []
                    let norms = cell.metadata["normals"]?.value as? [Float] ?? []
                    let idxs  = cell.metadata["indices"]?.value as? [UInt32] ?? []
                    let v3s = stride(from: 0, to: verts.count, by: 3).map {
                        SIMD3<Float>(verts[$0], verts[$0+1], verts[$0+2])
                    }
                    let n3s = stride(from: 0, to: norms.count, by: 3).map {
                        SIMD3<Float>(norms[$0], norms[$0+1], norms[$0+2])
                    }
                    meshes.append(Mesh(vertices: v3s, normals: n3s, indices: idxs))
                case "light":
                    let px = cell.metadata["px"]?.value as? Float ?? 0
                    let py = cell.metadata["py"]?.value as? Float ?? 0
                    let pz = cell.metadata["pz"]?.value as? Float ?? 0
                    let cr = cell.metadata["cr"]?.value as? Float ?? 1
                    let cg = cell.metadata["cg"]?.value as? Float ?? 1
                    let cb = cell.metadata["cb"]?.value as? Float ?? 1
                    let intensity = cell.metadata["intensity"]?.value as? Float ?? 1
                    lights.append(Light(
                        position: SIMD3(px,py,pz),
                        color: SIMD3(cr,cg,cb),
                        intensity: intensity
                    ))
                case "camera":
                    if let vm = cell.metadata["viewMatrix"]?.value as? [Float],
                       let pm = cell.metadata["projMatrix"]?.value as? [Float],
                       vm.count == 16, pm.count == 16 {
                        camera = Camera(
                            viewMatrix: simd_float4x4(rows: [
                                SIMD4(vm[0],vm[1],vm[2],vm[3]),
                                SIMD4(vm[4],vm[5],vm[6],vm[7]),
                                SIMD4(vm[8],vm[9],vm[10],vm[11]),
                                SIMD4(vm[12],vm[13],vm[14],vm[15])
                            ]),
                            projectionMatrix: simd_float4x4(rows: [
                                SIMD4(pm[0],pm[1],pm[2],pm[3]),
                                SIMD4(pm[4],pm[5],pm[6],pm[7]),
                                SIMD4(pm[8],pm[9],pm[10],pm[11]),
                                SIMD4(pm[12],pm[13],pm[14],pm[15])
                            ])
                        )
                    }
                default:
                    continue
                }
            }
        }
        return Scene(meshes: meshes, lights: lights, camera: camera)
    }
}
