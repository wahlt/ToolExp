// Sources/BridgeKit/BridgeKit.swift
//
//  BridgeKit.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Core marker protocol for all BridgeKit adaptors.
//  Enables dynamic lookup via PluginManager.
//

import Foundation

/// Marker protocol for any BridgeKit adaptor type.
/// Each adaptor must provide a unique `name` for registration.
public protocol BridgeAdaptor {
    /// Unique identifier used by PluginManager and registries.
    static var name: String { get }
}
