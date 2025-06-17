//
//  ToolApp.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ToolApp.swift
// ToolApp — @main entry and scene setup.
//

import SwiftUI
import StageKit

@main
struct ToolApp: App {
    @StateObject private var stageMng = StageMng()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stageMng)
        }
    }
}
