//
//  BuildServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// BuildServ.swift
// BuildKit — Orchestrates internal builds and code-generation pipelines.
//
// Uses SwiftBuild and SwiftSyntax tools under the hood.
//

import Foundation

/// Service to kick off and monitor builds of Tool-exp or plugins.
public actor BuildServ {
    private let swiftBuild: SwiftBuild
    private let swiftSyntax: SwiftSyntaxTool

    /// Initialize with concrete tool wrappers.
    public init(
        swiftBuild: SwiftBuild = .init(),
        swiftSyntax: SwiftSyntaxTool = .init()
    ) {
        self.swiftBuild = swiftBuild
        self.swiftSyntax = swiftSyntax
    }

    /// Run a SwiftPM build in the given package directory.
    /// - Parameter packagePath: file URL of the package root.
    public func buildPackage(at packagePath: URL) async throws {
        try await swiftBuild.run(in: packagePath)
    }

    /// Perform code-generation passes (e.g. entity mappers).
    /// - Parameter sourcePath: the folder to scan for macros.
    public func generateCode(in sourcePath: URL) async throws {
        try swiftSyntax.processMacros(in: sourcePath)
    }
}
