// File: Package.swift
//  ToolExp
//
//  Specification:
//  • SwiftPM manifest defining all library modules and the ToolApp executable.
//  • Ensures InvestigateKit and ServiceKit depend on RepKit so they can import it.
//
//  Discussion:
//  - Adds `RepKit` as a dependency of `InvestigateKit` and `ServiceKit` targets.
//  - Uses `executableTarget` API so the SwiftUI @main entrypoint is recognized.
//  - Processes Metal shaders under RenderKit’s Shaders folder.
//
//  Rationale:
//  • Aligns module dependencies with import statements in source files.
//  • Eliminates “no such module 'RepKit'” build errors.
//  • Centralizes target definitions for clarity and maintainability.
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "ToolExp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .executable(name: "ToolExp", targets: ["ToolApp"])
    ],
    dependencies: [
        // no external dependencies right now
    ],
    targets: [
        .target(name: "AIKit"),
        .target(name: "BridgeKit"),
        .target(name: "BuildKit"),
        .target(name: "DataServ"),
        .target(name: "EngineKit"),
        .target(name: "GestureKit"),
        .target(name: "IntegrationKit"),
        .target(
            name: "InvestigateKit",
            dependencies: ["RepKit"]     // allows import RepKit in Evaluate.swift
        ),
        .target(
            name: "ServiceKit",
            dependencies: ["RepKit"]     // allows import RepKit in FacetServ.swift
        ),
        .target(
            name: "ProjectKit",
            dependencies: ["DataServ"]
        ),
        .target(
            name: "RenderKit",
            path: "Sources/RenderKit",
            resources: [.process("Shaders")]
        ),
        .target(name: "RepKit"),
        .target(name: "StageKit"),
        .target(name: "ToolMath"),
        .target(name: "UXKit"),
        .target(name: "MLXIntegration"),
        .executableTarget(
            name: "ToolApp",
            dependencies: [
                "AIKit","BridgeKit","BuildKit","DataServ","EngineKit",
                "GestureKit","IntegrationKit","InvestigateKit","ProjectKit",
                "RenderKit","RepKit","ServiceKit","StageKit","ToolMath",
                "UXKit","MLXIntegration"
            ],
            path: "Sources/ToolApp",
            resources: []
        )
    ]
)
