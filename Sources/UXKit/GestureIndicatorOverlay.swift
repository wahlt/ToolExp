//
//  GestureIndicatorOverlay.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

import SwiftUI

/// Overlay view that shows the current gesture & parameters.
public struct GestureIndicatorOverlay: View {
    @StateObject private var indicator = GestureIndicator.shared

    public init() {}  // explicit for Swift 6.2

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Gesture: \(indicator.type)")
            Text("Touches: \(indicator.touches)")
            Text(indicator.parameters)
        }
        .font(.caption2)
        .padding(6)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(6)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .allowsHitTesting(false)
    }
}
