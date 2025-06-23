// File: ToolApp/HelloWorldView.swift
//
//  HelloWorldView.swift
//  ToolApp
//
//  Specification:
//  • Shows a bouncing copper ball in an HDR-capable SwiftUI canvas.
//  • Runs at up to 120 Hz via TimelineView and supports ProMotion.
//
//  Discussion:
//  Migrating from `Timer` to `TimelineView` ensures smooth animations
//  on high-refresh displays and keeps physics in sync with render loop.
//
//  Rationale:
//  • Leverages SwiftUI’s animation timeline for performance.
//  TODO:
//    – [ ] Integrate a proper Metal shader for HDR P3 lighting.
//    – [ ] Max-out performance for M4 iPad Pro (1 TB, 16 GB).
//
//  Dependencies: SwiftUI, UXKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import SwiftUI

public struct HelloWorldView: View {
    @State private var position = CGPoint(x: 100, y: 100)
    @State private var velocity = CGVector(dx: 60, dy: 40)
    @EnvironmentObject var coordinator: ToolAppCoordinator

    // Constants
    private let radius: CGFloat = 50
    private let gravity = CGVector(dx: 0, dy: 0.05 * 980)  // px/s²
    private let damping: CGFloat = 0.99

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ColorPalette.background.ignoresSafeArea()

                // Copper ball
                Circle()
                    .fill(Color(red: 0.72, green: 0.45, blue: 0.20, opacity: 1.0))
                    .frame(width: radius*2, height: radius*2)
                    .position(position)
                    .gesture(
                        DragGesture(minimumDistance: 0).onEnded { value in
                            let newVel = CGVector(
                                dx: (position.x - value.location.x) * 5,
                                dy: (position.y - value.location.y) * 5
                            )
                            velocity = newVel
                        }
                    )

                // Stage switch
                VStack {
                    Spacer()
                    Button("Enter ToolDev") {
                        coordinator.loadStage("ToolDev")
                    }
                    .padding()
                    .background(ColorPalette.accent)
                    .cornerRadius(UXTheme.cornerRadius)
                    .foregroundColor(.white)
                }
            }
            // Use SwiftUI’s TimelineView for 120Hz updates
            .timelineView(.animation(minimumInterval: 1.0/120.0)) { context in
                let _ = context  // ignore; use fixed dt
                updatePhysics(in: geo.size)
            }
        }
    }

    /// Physics update called each frame.
    private func updatePhysics(in size: CGSize) {
        // Gravity
        velocity.dx += gravity.dx * (1.0/120.0)
        velocity.dy += gravity.dy * (1.0/120.0)
        // Integrate
        position.x += velocity.dx * (1.0/120.0)
        position.y += velocity.dy * (1.0/120.0)
        // Bounce
        if position.x < radius || position.x > size.width - radius {
            velocity.dx = -velocity.dx * damping
            position.x = min(max(position.x, radius), size.width - radius)
        }
        if position.y < radius || position.y > size.height - radius {
            velocity.dy = -velocity.dy * damping
            position.y = min(max(position.y, radius), size.height - radius)
        }
        velocity.dx *= damping
        velocity.dy *= damping
    }
}
