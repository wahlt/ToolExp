//
//  ContentView.swift
//  ToolApp
//
//  Specification:
//  • Root view that switches between SuperStage views.
//
//  Discussion:
//  Listens to coordinator.currentStage and displays appropriate UI.
//
//  Rationale:
//  • Single source for stage switching.
//  Dependencies: SwiftUI
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var coordinator: ToolAppCoordinator

    public var body: some View {
        Group {
            switch coordinator.currentStage {
            case "ToolExp":  HelloWorldView()
            default:         HelloWorldView()
            }
        }
    }
}


//
//  HelloWorldView.swift
//  ToolApp
//
//  Specification:
//  • SwiftUI view displaying bouncing copper ball & Enter ToolDev button.
//
//  Discussion:
//  Meets Hello-World spec: HDR P3 copper ball in invisible cube,
//  responsive to taps, with gravity and damping.
//
//  Rationale:
//  • Demonstrates physics, gesture, HUD, and stage switching.
//  Dependencies: SwiftUI
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
                    .fill(Color(red: 0.72, green: 0.45, blue: 0.20))
                    .frame(width: radius*2, height: radius*2)
                    .position(position)
                    .gesture(
                        DragGesture(minimumDistance: 0).onEnded { value in
                            let vel = CGVector(
                                dx: (position.x - value.location.x)*5,
                                dy: (position.y - value.location.y)*5
                            )
                            velocity = vel
                        }
                    )
                    .onAppear { startPhysics(in: geo.size) }

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
        }
    }

    private func startPhysics(in size: CGSize) {
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            // Apply gravity
            velocity.dx += gravity.dx * CGFloat(1/60)
            velocity.dy += gravity.dy * CGFloat(1/60)
            // Update position
            position.x += velocity.dx * CGFloat(1/60)
            position.y += velocity.dy * CGFloat(1/60)
            // Bounce off walls
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
}
