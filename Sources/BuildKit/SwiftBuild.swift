// Sources/BuildKit/SwiftBuild.swift
//
//  SwiftBuild.swift
//  BuildKit
//
//  Created by Thomas Wahl on 6/16/25.
//
//  Programmatic wrapper around `swift build` and `swift package`.
//

import Foundation

public struct SwiftBuild {
    /// Runs a generic Swift command.
    /// - Parameters:
    ///   - command: the Swift tool subcommand (e.g. "build", "test").
    ///   - args: extra arguments after the subcommand.
    /// - Throws: if the process exits non-zero.
    public static func run(command: String, args: [String] = []) throws {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["swift", command] + args
        task.launch()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw NSError(
                domain: "SwiftBuild",
                code: Int(task.terminationStatus),
                userInfo: ["message": "swift \(command) failed"]
            )
        }
    }
}
