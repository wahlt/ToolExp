//
//  ContentView.swift
//  ToolApp
//
//  1. Purpose
//     Root SwiftUI view that switches between the hello demo and project canvas.
// 2. Dependencies
//     SwiftUI, BridgeKit, UXKit
// 3. Overview
//     Observes the `ToolAppCoordinator` for current screen state.
// 4. Usage
//     Instantiated by the main App in `main.swift`.
// 5. Notes
//     Expands easily for additional screens.

import SwiftUI
import BridgeKit
import UXKit

public struct ContentView: View {
    @EnvironmentObject private var coordinator: ToolAppCoordinator

    public var body: some View {
        Group {
            switch coordinator.currentScreen {
            case .hello:
                HelloWorldView()
            case .project(let rep):
                // StageKit provides a default view for a RepStruct
                StageKit.defaultView(for: rep)
            }
        }
        .onAppear {
            coordinator.start()
        }
    }
}
