//
//  GestureIndicator.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

import SwiftUI

/// Singleton object for broadcasting current gesture state.
@MainActor
public final class GestureIndicator: ObservableObject, Sendable {
    public static let shared = GestureIndicator()
    private init() {}

    /// Name of the current gesture (“Drag”, “Rotate”, etc.)
    @Published public var type: String = "None"

    /// Number of touches involved (1, 2…)
    @Published public var touches: Int = 0

    /// Any additional parameters to show (e.g. “dx: 10, dy: 5, angle: 23.4”)
    @Published public var parameters: String = ""
}
