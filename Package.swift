// Package.swift

// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ToolExp",
    platforms: [
        .iOS(.v17), .macOS(.v14), .visionOS(.v1)
    ],
    products: [
        .app(name: "ToolExp", targets: ["ToolApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-syntax-builder.git", branch: "main")
    ],
    targets: [
        .target(name: "ServiceKit",    path: "ServiceKit"),
        .target(name: "StageKit",      path: "StageKit"),
        .target(name: "ToolMath",      path: "ToolMath"),
        .target(name: "UXKit",         path: "UXKit"),
        .target(name: "ToolApp",       dependencies: ["ServiceKit","StageKit","ToolMath","UXKit"], path: "ToolApp"),
    ]
)
