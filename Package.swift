// swift-tools-version:7.0
import PackageDescription

let package = Package(
    name: "ToolExp",
    platforms: [
        .iOS(.v26),    // iPadOS 26
        .macOS(.v15)
    ],
    products: [
        .library(   name: "RepKit",    targets: ["RepKit"]),
        .library(   name: "DataServ",  targets: ["DataServ"]),
        .library(   name: "StageKit",  targets: ["StageKit"]),
        .library(   name: "RenderKit", targets: ["RenderKit"]),
        .library(   name: "UXKit",     targets: ["UXKit"]),
        .executable(name: "ToolApp",   targets: ["ToolApp"])
    ],
    dependencies: [
        // Local MLX.swift package for Metal-4 ML integration
        .package(path: "MLX.swift"),
        // Apple-provided utility packages
        .package(url: "https://github.com/apple/swift-algorithms.git",   from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git",  from: "1.0.0")
    ],
    targets: [
        .target(
            name: "RepKit",
            dependencies: [
                .product(name: "Algorithms",  package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .target(
            name: "DataServ",
            dependencies: ["RepKit"],
            swiftSettings: [
                .unsafeFlags(["-enable-experimental-feature", "Macros"])
            ]
        ),
        .target(
            name: "StageKit",
            dependencies: ["RepKit", "DataServ"]
        ),
        .target(
            name: "RenderKit",
            dependencies: [
                "RepKit",
                .product(name: "MLXIntegration", package: "MLX.swift")
            ],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("MetalPerformanceShaders"),
                .linkedFramework("MetalFX")
            ]
        ),
        .target(
            name: "UXKit",
            dependencies: ["RepKit", "DataServ", "StageKit"]
        ),
        .executableTarget(
            name: "ToolApp",
            dependencies: ["StageKit", "RenderKit", "UXKit"]
        )
        // Uncomment and add proper Test folders when ready:
        // .testTarget(name: "RepKitTests",   dependencies: ["RepKit"]),
        // .testTarget(name: "DataServTests", dependencies: ["DataServ"])
    ]
)
