//
//  ToolExpApp.swift
//  ToolApp
//
//  Specification:
//  • SwiftUI App entrypoint for ToolExp target.
//
//  Discussion:
//  Sets up initial environment, loads last used stage and rep.
//
//  Rationale:
//  • @main simplifies launch.
//  Dependencies: SwiftUI, ServiceKit, StageKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import SwiftUI
import ServiceKit
import StageKit

@main
struct ToolExpApp: App {
    @StateObject private var coordinator = ToolAppCoordinator()
    @AppStorage("lastStage") private var lastStage: String?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
                .onAppear {
                    coordinator.loadStage(lastStage)
                }
        }
    }
}
