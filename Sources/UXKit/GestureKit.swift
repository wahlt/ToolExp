//
//  GestureKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// GestureKit.swift
// UXKit — Aggregates all gesture types and recognition parameters.
//
// Provides configurable thresholds for long-press, swipe velocity, etc.
//

import SwiftUI

public struct GestureKit {
    /// Minimum duration (sec) to recognize a long press.
    public static var longPressDuration: Double = 0.5

    /// Minimum travel distance (points) to recognize a swipe.
    public static var swipeThreshold: CGFloat = 20

    /// Gesture parameter UI for tuning in flight.
    public static func parameterSliders() -> some View {
        VStack {
            HStack {
                Text("Long-Press:")
                Slider(value: &longPressDuration, in: 0.1...2.0)
                Text(String(format: "%.2f", longPressDuration))
            }
            HStack {
                Text("Swipe Threshold:")
                Slider(value: &swipeThreshold, in: 5...100)
                Text(String(format: "%.0f", swipeThreshold))
            }
        }
        .padding()
    }
}
