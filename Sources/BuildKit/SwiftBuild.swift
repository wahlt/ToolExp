//
//  SwiftBuild.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// SwiftBuild.swift
// BuildKit — Wrapper over SwiftPM CLI for builds and tests.
//

import Foundation

/// Executes SwiftPM build/test commands programmatically.
public struct SwiftBuild {
    /// Run `swift build` in the given directory.
    public func run(in packagePath: URL) async throws {
        try await run(command: ["swift", "build"], in: packagePath)
    }

    /// Helper to spawn a process and await its exit.
    private func run(command: [String], in cwd: URL) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = command
        process.currentDirectoryURL = cwd
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            throw NSError(
                domain: "SwiftBuild",
                code: Int(process.terminationStatus),
                userInfo: [NSLocalizedDescriptionKey: "Command \(command) failed"]
            )
        }
    }
}
