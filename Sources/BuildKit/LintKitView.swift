//
//  LintKitView.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BuildKit/LintKitView.swift
//
//  LintKitView.swift
//  BuildKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  SwiftUI interface for on-demand linting.

import SwiftUI

public struct LintKitView: View {
    @State private var path: String = ""
    @State private var output: String = ""

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Path to source…", text: $path)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Run SwiftLint") {
                runLint()
            }
            ScrollView {
                Text(output)
                    .font(.system(.body, design: .monospaced))
                    .padding()
            }
        }
        .padding()
    }

    private func runLint() {
        DispatchQueue.global().async {
            do {
                try LintKitService.shared.lint(at: path)
                appendOutput("Lint passed at \(path)")
            } catch {
                appendOutput("Lint error: \(error)")
            }
        }
    }

    private func appendOutput(_ text: String) {
        DispatchQueue.main.async {
            output += text + "\n"
        }
    }
}
