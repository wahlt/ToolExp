//
//  ModuleMng.swift
//  IntegrationKit
//
//  Specification:
//  • Manages dynamic loading/unloading of Kit modules at runtime.
//  • Supports registering ModuleDescriptor and lookup.
//
//  Discussion:
//  In a plugin architecture, modules can arrive via hot-reload.
//  ModuleMng keeps a registry and handles lifecycle events.
//
//  Rationale:
//  • Single point to discover available “Kits.”
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct ModuleDescriptor {
    public let name: String
    public let version: String
}

public class ModuleMng {
    public static let shared = ModuleMng()
    private init() {}
    private var modules: [String: ModuleDescriptor] = [:]

    /// Registers a module descriptor.
    public func register(_ desc: ModuleDescriptor) {
        modules[desc.name] = desc
    }

    /// Returns all registered modules.
    public func allModules() -> [ModuleDescriptor] {
        return Array(modules.values)
    }

    /// Lookup a module by name.
    public func descriptor(named name: String) -> ModuleDescriptor? {
        return modules[name]
    }
}
