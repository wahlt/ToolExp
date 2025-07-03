//
//  StageManager.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  StageManager.swift
//  UXKit
//
//  1. Purpose
//     Coordinates switching between multiple stages (tabs, layouts).
// 2. Dependencies
//     SwiftUI, Combine
// 3. Overview
//     Holds an array of `Stage` instances and publishes current index.
// 4. Usage
//     Use in a parent view to switch canvases.
// 5. Notes
//     Supports keyboard shortcuts and gestures for tabbing.

import SwiftUI
import Combine

public final class StageManager: ObservableObject {
    @Published public private(set) var stages: [AnyView] = []
    @Published public var currentIndex: Int = 0

    public init() {}

    /// Adds a new stage view.
    public func addStage<V: View>(_ view: V) {
        stages.append(AnyView(view))
    }

    /// Switches to next stage (wraps around).
    public func nextStage() {
        currentIndex = (currentIndex + 1) % max(stages.count, 1)
    }

    /// Switches to previous stage.
    public func previousStage() {
        currentIndex = (currentIndex - 1 + stages.count) % max(stages.count, 1)
    }
}
