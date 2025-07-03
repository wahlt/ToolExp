// swift-tools-version:6.2
// Package manifest for ToolExp00 — fully tensorized Tool

import PackageDescription

let package = Package(
    name: "ToolExp00",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // The main app executable
        .executable(
            name: "ToolApp",
            targets: ["ToolApp"]
        )
    ],
    targets: [
        // Core AI & UI
        .target(
            name: "AIKit",
            path: "Sources/AIKit"
        ),
        .target(
            name: "BridgeKit",
            dependencies: ["RepKit"],
            path: "Sources/BridgeKit"
        ),

        // Build & Dev Tools
        .target(
            name: "BuildKit",
            path: "Sources/BuildKit"
        ),

        // Continuity & Sync
        .target(
            name: "CloudSyncKit",
            dependencies: ["ContinuityKit"],
            path: "Sources/CloudSyncKit"
        ),
        .target(
            name: "ContinuityKit",
            dependencies: ["RepKit"],
            path: "Sources/ContinuityKit"
        ),

        // Data layer (with optional tensor mirror)
        .target(
            name: "DataServ",
            dependencies: ["MLXIntegration", "RepKit"],
            path: "Sources/DataServ"
        ),

        // Core Engines
        .target(
            name: "EngineKit",
            dependencies: ["BridgeKit", "RepKit", "PhysicsKit"],
            path: "Sources/EngineKit",
            exclude: ["PhysicsKit"] // PhysicsKit is its own target
        ),
        .target(
            name: "PhysicsKit",
            path: "Sources/EngineKit/PhysicsKit",
            linkerSettings: [
                .linkedFramework("MetalPerformanceShadersGraph")
            ]
        ),

        // Integration & Investigation
        .target(
            name: "IntegrationKit",
            dependencies: ["RepKit"],
            path: "Sources/IntegrationKit"
        ),
        .target(
            name: "InvestigateKit",
            path: "Sources/InvestigateKit"
        ),

        // MLX bindings & graph caching
        .target(
            name: "MLXIntegration",
            path: "Sources/MLXIntegration"
        ),
        .target(
            name: "MLXRepKit",
            path: "Sources/MLXRepKit",
            linkerSettings: [
                .linkedFramework("MetalPerformanceShadersGraph")
            ]
        ),

        // Project & Rep core
        .target(
            name: "ProjectKit",
            dependencies: ["RepKit"],
            path: "Sources/ProjectKit"
        ),
        .target(
            name: "RepKit",
            path: "Sources/RepKit"
        ),

        // Rendering & visualization
        .target(
            name: "RenderKit",
            dependencies: ["MLXIntegration"],
            path: "Sources/RenderKit",
            resources: [
                .process("Shaders")
            ],
            linkerSettings: [
                .linkedFramework("MetalKit"),
                .linkedFramework("MetalPerformanceShadersGraph")
            ]
        ),

        // System services & utilities
        .target(
            name: "ServiceKit",
            dependencies: ["RepKit"],
            path: "Sources/ServiceKit"
        ),

        // Spatial audio DSP
        .target(
            name: "SpatialAudioKit",
            dependencies: ["MLXIntegration"],
            path: "Sources/SpatialAudioKit",
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("MetalPerformanceShadersGraph")
            ]
        ),

        // General tensor‐core utilities
        .target(
            name: "TensorCoreKit",
            dependencies: ["MLXIntegration"],
            path: "Sources/TensorCoreKit",
            linkerSettings: [
                .linkedFramework("MetalPerformanceShadersGraph")
            ]
        ),

        // Math & tensor utilities
        .target(
            name: "ToolMath",
            dependencies: ["MLXIntegration"],
            path: "Sources/ToolMath"
        ),

        // UI toolkit (gestures, DomKit, MagicKit, etc.)
        .target(
            name: "UXKit",
            dependencies: ["RepKit"],
            path: "Sources/UXKit"
        ),

        // Asset & inventory management
        .target(
            name: "WarehouseKit",
            dependencies: ["RepKit"],
            path: "Sources/WarehouseKit"
        ),

        // The app entry point
        .executableTarget(
            name: "ToolApp",
            dependencies: [
                "AIKit","BridgeKit","BuildKit","CloudSyncKit","ContinuityKit",
                "DataServ","EngineKit","PhysicsKit","IntegrationKit","InvestigateKit",
                "MLXIntegration","MLXRepKit","ProjectKit","RepKit","RenderKit",
                "ServiceKit","SpatialAudioKit","TensorCoreKit","ToolMath",
                "UXKit","WarehouseKit"
            ],
            path: "Sources/ToolApp"
        )
    ]
)
