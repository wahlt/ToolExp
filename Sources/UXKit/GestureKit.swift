//
//  GestureKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

import SwiftUI

/// Configurable gesture thresholds & tuning UI.
@MainActor
public struct GestureKit {
    /// How long (seconds) to hold before a long-press registers.
    public static var longPressDuration: Double = 0.5

    /// How far (points) to move before a swipe registers.
    public static var swipeThreshold: CGFloat = 20

    /// A pair of sliders allowing in-flight tuning.
    public static func parameterSliders() -> some View {
        VStack {
            HStack {
                Text("Long-Press:")
                Slider(
                    value: Binding(
                        get: { GestureKit.longPressDuration },
                        set: { GestureKit.longPressDuration = $0 }
                    ),
                    in: 0.1...2.0
                )
                Text(String(format: "%.2f", GestureKit.longPressDuration))
            }
            HStack {
                Text("Swipe Threshold:")
                Slider(
                    value: Binding(
                        get: { GestureKit.swipeThreshold },
                        set: { GestureKit.swipeThreshold = $0 }
                    ),
                    in: 5...100
                )
                Text(String(format: "%.0f", GestureKit.swipeThreshold))
            }
        }
        .padding()
    }
}
