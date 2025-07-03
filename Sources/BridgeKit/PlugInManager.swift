//
//  PlugInManager.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/PluginManager.swift
//
//  PluginManager.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Registers and invokes BridgeAdaptor plugins by name.
//

import Foundation

/// Manages a registry of `BridgeAdaptor` types.
public final class PluginManager: BridgeAdaptor {
    public static let name = "PluginManager"
    private var plugins: [String: BridgeAdaptor.Type] = [:]

    public init() {}

    /// Registers an adaptor type for discovery.
    public func register(plugin: BridgeAdaptor.Type) {
        plugins[plugin.name] = plugin
    }

    /// Instantiates and returns a plugin by name, or `nil`.
    /// - Parameter name: Unique adaptor name.
    public func makePlugin(named name: String) -> BridgeAdaptor? {
        guard let type = plugins[name] else { return nil }
        return type.init()
    }

    /// All registered plugin names.
    public var registeredNames: [String] {
        Array(plugins.keys)
    }
}
