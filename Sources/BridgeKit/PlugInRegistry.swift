//
//  PlugInRegistry.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/PluginRegistry.swift
//
//  PluginRegistry.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Low‐level name→adaptor mapping store.
//

import Foundation

public final class PluginRegistry {
    private var storage: [String: BridgeAdaptor.Type] = [:]

    public init() {}

    /// Add an adaptor type under its static `name`.
    public func register(_ adaptor: BridgeAdaptor.Type) {
        storage[adaptor.name] = adaptor
    }

    /// Look up an adaptor type by name.
    public func adaptor(named name: String) -> BridgeAdaptor.Type? {
        return storage[name]
    }

    /// All registered adaptor names.
    public var allNames: [String] {
        Array(storage.keys)
    }
}
