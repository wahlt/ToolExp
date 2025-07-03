//
//  ToolAppCoordinator.swift
//  ToolApp
//
//  1. Purpose
//     Manages top-level app navigation and state.
// 2. Dependencies
//     SwiftUI, RepKit, UXKit
// 3. Overview
//     Holds an enum `Screen` and publishes it to switch views.
// 4. Usage
//     Provided as an `EnvironmentObject` to `ContentView`.
// 5. Notes
//     Automatically transitions from `.hello` to `.project`.

import SwiftUI
import RepKit
import UXKit

public final class ToolAppCoordinator: ObservableObject {
    public enum Screen {
        case hello
        case project(rep: RepStruct)
    }

    @Published public private(set) var currentScreen: Screen = .hello

    /// Kick off startup sequence.
    public func start() {
        // After a brief pause, load an empty project
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let rep = RepStruct()               // new empty project
            self.currentScreen = .project(rep: rep)
        }
    }
}
