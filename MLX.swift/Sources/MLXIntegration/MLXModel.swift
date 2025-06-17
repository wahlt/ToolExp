//
//  MLXModel.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// swift-tools-version:6.2
import PackageDescription

let package = Package(
  name: "MLX.swift",
  platforms: [
    .iOS(.v17),    // iPadOS 26 → SDK iOS17
    .macOS(.v15)
  ],
  products: [
    .library(name: "MLXIntegration", targets: ["MLXIntegration"])
  ],
  dependencies: [ /* none */ ],
  targets: [
    .target(
      name: "MLXIntegration",
      dependencies: []
    )
  ]
)
