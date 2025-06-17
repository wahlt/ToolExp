// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "ToolMiniUltra",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v26),      // iPadOS 26 ≈ iOS 17
        .macOS(.v15),    // macOS 15
        .visionOS(.v26)   // visionOS 26 ≈ v1
    ],
    products: [
        // Core libraries
        .library(name: "AIKit",           targets: ["AIKit"]),
        .library(name: "BridgeKit",       targets: ["BridgeKit"]),
        .library(name: "BuildKit",        targets: ["BuildKit"]),
        .library(name: "DataServ",        targets: ["DataServ"]),
        .library(name: "EngineKit",       targets: ["EngineKit"]),
        .library(name: "InvestigateKit",  targets: ["InvestigateKit"]),
        .library(name: "IntegrationKit",  targets: ["IntegrationKit"]),
        .library(name: "MacroKit",        targets: ["MacroKit"]),
        .library(name: "MLXIntegration",  targets: ["MLXIntegration"]),
        .library(name: "ProjectKit",      targets: ["ProjectKit"]),
        .library(name: "RenderKit",       targets: ["RenderKit"]),
        .library(name: "RepKit",          targets: ["RepKit"]),
        .library(name: "ServiceKit",      targets: ["ServiceKit"]),
        .library(name: "StageKit",        targets: ["StageKit"]),
        .executable(name: "ToolApp",      targets: ["ToolApp"]), // SwiftUI App
        .library(name: "ToolMath",        targets: ["ToolMath"]),
        .library(name: "UXKit",           targets: ["UXKit"]),
    ],
    dependencies: [
        // No external dependencies for Tool-exp
    ],
    targets: [
        // AIKit
        .target(name: "AIKit", path: "Sources/AIKit"),

        // BridgeKit
        .target(name: "BridgeKit", path: "Sources/BridgeKit"),

        // BuildKit
        .target(name: "BuildKit", path: "Sources/BuildKit"),

        // DataServ
        .target(name: "DataServ", path: "Sources/DataServ"),

        // EngineKit
        .target(name: "EngineKit", path: "Sources/EngineKit"),

        // InvestigateKit
        .target(name: "InvestigateKit", path: "Sources/InvestigateKit"),

        // IntegrationKit
        .target(name: "IntegrationKit", path: "Sources/IntegrationKit"),

        // MacroKit
        .target(name: "MacroKit", path: "Sources/MacroKit"),

        // MLXIntegration
        .target(name: "MLXIntegration", path: "Sources/MLXIntegration"),

        // ProjectKit
        .target(name: "ProjectKit", path: "Sources/ProjectKit"),

        // RenderKit + shaders
        .target(
            name: "RenderKit",
            path: "Sources/RenderKit",
            resources: [.process("Shaders")]
        ),

        // RepKit
        .target(name: "RepKit", path: "Sources/RepKit"),

        // ServiceKit
        .target(name: "ServiceKit", path: "Sources/ServiceKit"),

        // StageKit
        .target(name: "StageKit", path: "Sources/StageKit"),

        // ToolApp
        .executableTarget(name: "ToolApp", path: "Sources/ToolApp"),

        // ToolMath
        .target(name: "ToolMath", path: "Sources/ToolMath"),

        // UXKit
        .target(name: "UXKit", path: "Sources/UXKit"),
    ]
)
