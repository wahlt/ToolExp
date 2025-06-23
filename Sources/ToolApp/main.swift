//
//  main.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/23/25.
//

// File: Sources/ToolApp/main.swift
//
//  main.swift
//  ToolApp
//
//  Specification:
//  • Entry point for the ToolExp executable target.
//  • Defines the @main SwiftUI App structure.
//
//  Discussion:
//  Swift Package Manager requires an executable target to contain a
//  `main.swift` or a file with a `@main` attribute. By placing the
//  @main-annotated App struct in `main.swift`, SPM will recognize
//  `ToolApp` as an executable.
//
//  Rationale:
//  • Ensures the `ToolApp` target satisfies SPM’s executable requirements.
//  • Serves as the launch point for the SwiftUI-based ToolExp application.
//
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
