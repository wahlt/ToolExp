//
//  HelloWorldView.swift
//  ToolApp
//
//  1. Purpose
//     Simple MetalKit-based demo showing a rotating sphere.
// 2. Dependencies
//     SwiftUI, MetalKit, RenderKit
// 3. Overview
//     Sets up an MTKView, renders a sphere mesh via `DifferentiableRenderer`.
// 4. Usage
//     Displayed at launch before loading a project.
// 5. Notes
//     Uses a basic Lambertian shading in `PathTracerKernel`.

import SwiftUI
import MetalKit
import RenderKit

public struct HelloWorldView: UIViewRepresentable {
    public func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1)
        view.delegate = context.coordinator
        context.coordinator.setup(in: view)
        return view
    }

    public func updateUIView(_ uiView: MTKView, context: Context) {
        // nothing to update
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public class Coordinator: NSObject, MTKViewDelegate {
        private var renderer: DifferentiableRenderer!
        private var scene: Scene!

        /// Called once when the view is created.
        func setup(in view: MTKView) {
            guard let dev = view.device else { fatalError("MTKView has no device") }
            renderer = DifferentiableRenderer(device: dev)
            // Build a unit sphere mesh
            let mesh = GeometryPrimitives.sphere(radius: 0.5, segments: 32)
            let light = Light(position: [2,2,2], color: [1,1,1], intensity: 2)
            let cam   = Camera(
                viewMatrix: float4x4(translation: [0,0,2]).inverse,
                projectionMatrix: float4x4(perspectiveFOV: .pi/4, aspect: Float(view.drawableSize.width/view.drawableSize.height), nearZ: 0.1, farZ: 10)
            )
            scene = Scene(meshes: [mesh], lights: [light], camera: cam)
        }

        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // update projection if needed
        }

        public func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable else { return }
            do {
                let tex = try renderer.render(scene: scene)
                // Blit to screen
                let cmdQ = view.device!.makeCommandQueue()!
                let cmd  = cmdQ.makeCommandBuffer()!
                let blit = cmd.makeBlitCommandEncoder()!
                blit.copy(from: tex,
                          sourceSlice: 0,
                          sourceLevel: 0,
                          sourceOrigin: MTLOrigin(x:0,y:0,z:0),
                          sourceSize: MTLSize(width: tex.width, height: tex.height, depth: 1),
                          to: drawable.texture,
                          destinationSlice: 0,
                          destinationLevel: 0,
                          destinationOrigin: MTLOrigin(x:0,y:0,z:0))
                blit.endEncoding()
                cmd.present(drawable)
                cmd.commit()
            } catch {
                print("HelloWorldView render error: \(error)")
            }
        }
    }
}
