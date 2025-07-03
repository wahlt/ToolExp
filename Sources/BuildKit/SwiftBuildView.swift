//
//  SwiftBuildView.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BuildKit/SwiftBuildView.swift
//
//  SwiftBuildView.swift
//  BuildKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  SwiftUI interface to run `swift build`.

import SwiftUI

public struct SwiftBuildView: View {
    @State private var path: String = ""
    @State private var log: String = ""

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Package path…", text: $path)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Build Package") {
                runBuild()
            }
            ScrollView {
                Text(log)
                    .font(.system(.body, design: .monospaced))
                    .padding()
            }
        }
        .padding()
    }

    private func runBuild() {
        DispatchQueue.global().async {
            do {
                try BuildService.shared.build(at: path)
                appendLog("Build succeeded at \(path)")
            } catch {
                appendLog("Build failed: \(error)")
            }
        }
    }

    private func appendLog(_ line: String) {
        DispatchQueue.main.async {
            log += line + "\n"
        }
    }
}
