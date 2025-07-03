//
//  main.swift
//  ToolApp
//
//  1. Purpose
//     Application entry point for ToolExp.
// 2. Dependencies
//     SwiftUI
// 3. Overview
//     Registers the main `App` struct and injects `ToolAppCoordinator`.
// 4. Usage
//     Run by the system; no manual invocation required.
// 5. Notes
//     Customize scenes (e.g. Settings) here as needed.

import SwiftUI

@main
struct ToolExpApp: App {
    @StateObject private var coordinator = ToolAppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
        }
    }
}
