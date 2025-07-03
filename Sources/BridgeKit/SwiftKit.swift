//
//  SwiftKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/SwiftKit.swift
//
//  SwiftKit.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Utilities around Swift data formatting and reflection.
//

import Foundation

public struct SwiftKit: BridgeAdaptor {
    public static let name = "SwiftKit"

    /// Formats a `Date` into a medium‐style string.
    public static func humanReadable(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }

    /// Reflects property labels from any `Codable` value.
    public static func reflectProperties(of value: Codable) -> [String] {
        return Mirror(reflecting: value)
            .children
            .compactMap { $0.label }
    }
}
