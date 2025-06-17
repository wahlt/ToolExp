//
//  BridgeKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// BridgeKit.swift
// BridgeKit — Root namespace for all external adapters.
//
// Centralizes logging, authentication, and registration of adaptors.
//

import Foundation

/// Protocol that every external system adaptor must conform to.
public protocol SystemAdaptor {
    /// A unique name, e.g. "OpenAI", "Wolfram", "WeatherKit".
    static var name: String { get }
    /// Perform any one-time setup (e.g. API keys).
    static func configure()
}

/// Manager that holds registered adaptors.
public struct BridgeKit {
    private static var adaptors: [SystemAdaptor.Type] = []

    /// Register an adaptor for later use.
    public static func register(_ adaptor: SystemAdaptor.Type) {
        adaptors.append(adaptor)
        adaptor.configure()
    }

    /// List all registered adaptor names.
    public static func registeredNames() -> [String] {
        return adaptors.map { $0.name }
    }
}
