//
//  Package.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// ToolExp/MLX.swift/Package.swift
// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "MLX.swift",
    platforms: [
        .iOS(.v17), .macOS(.v15)
    ],
    products: [
        .library(name: "MLXIntegration", targets: ["MLXIntegration"])
    ],
    targets: [
        .target(
            name: "MLXIntegration",
            dependencies: [],
            path: "Sources/MLXIntegration"
        )
    ]
)
