//
//  ContentView.swift
//  ToolApp
//
//  Specification:
//  • Root view that switches between SuperStage views.
//
//  Discussion:
//  Listens to coordinator.currentStage and displays appropriate UI.
//
//  Rationale:
//  • Single source for stage switching.
//  Dependencies: SwiftUI
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var coordinator: ToolAppCoordinator

    public var body: some View {
        Group {
            switch coordinator.currentStage {
            case "ToolExp":  HelloWorldView()
            default:         HelloWorldView()
            }
        }
    }
}


