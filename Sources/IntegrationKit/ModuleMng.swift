// File: Sources/IntegrationKit/ModuleMng.swift
//  IntegrationKit
//
//  Specification:
//  • Defines ModuleDescriptor and ModuleMng as the central registry for dynamic plugins.
//  • ModuleDescriptor holds metadata for each plugin module.
//  • ModuleMng hosts a singleton and a map of registered descriptors.
//
//  Discussion:
//  ModuleDescriptor is a simple value type encapsulating a module’s identity and location.
//  ModuleMng is marked @MainActor to isolate its shared instance and state.
//  We expose `register(_:)` and `descriptor(for:)` methods for managing modules.
//
//  Rationale:
//  • Providing ModuleDescriptor here prevents missing-type errors.
//  • @MainActor on ModuleMng silences concurrency‐safety warnings for `shared`.
//  • Internal `modules` allows extensions (e.g. HotReload) to clear state safely.
//
//  TODO:
//  • Expand ModuleDescriptor with version, dependencies, and entrypoints.
//  • Implement `register(_:)` to load bundles and populate descriptors.
//  • Add unit tests for registry operations.
//
//  Dependencies: Foundation
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Metadata describing a dynamically loaded module.
public struct ModuleDescriptor: Codable, Sendable {
    /// Unique name of the module.
    public let name: String
    /// File URL or bundle identifier where the module resides.
    public let bundleURL: URL

    public init(name: String, bundleURL: URL) {
        self.name = name
        self.bundleURL = bundleURL
    }
}

@MainActor
public class ModuleMng {
    /// Shared singleton for global module management.
    public static let shared = ModuleMng()

    /// Internal map: module name → descriptor.
    /// Allows hot-reload extension to clear and re-register modules.
    internal var modules: [String: ModuleDescriptor] = [:]

    private init() {}

    /// Registers a new module descriptor.
    /// - Parameter descriptor: The descriptor to add or replace.
    public func register(_ descriptor: ModuleDescriptor) {
        modules[descriptor.name] = descriptor
    }

    /// Looks up a registered descriptor by module name.
    /// - Parameter name: The module name to query.
    /// - Returns: The ModuleDescriptor if registered, or nil.
    public func descriptor(for name: String) -> ModuleDescriptor? {
        return modules[name]
    }

    /// Clears all registered modules.
    public func clearModules() {
        modules.removeAll()
    }
}
