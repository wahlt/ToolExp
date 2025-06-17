//
//  ModuleMng.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ModuleMng.swift
// IntegrationKit — Core manager for dynamic plugin modules.
//

import Foundation

/// Describes a dynamically loaded module plugin.
public struct ModuleDescriptor: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let path: URL
}

/// Actor responsible for loading/unloading modules.
public actor ModuleMng {
    private var modules: [UUID: ModuleDescriptor] = [:]

    public init() {}

    /// Load a module bundle at the given URL.
    public func loadModule(at url: URL) throws {
        // TODO: Validate .bundle, ensure code-signed if required
        let descriptor = ModuleDescriptor(
            id: UUID(),
            name: url.deletingPathExtension().lastPathComponent,
            path: url
        )
        modules[descriptor.id] = descriptor
        // TODO: Dynamically load with `Bundle(path:)`
    }

    /// Unload a previously loaded module.
    public func unloadModule(id: UUID) {
        modules.removeValue(forKey: id)
        // TODO: Perform any clean-up required by the plugin
    }

    /// List all currently loaded modules.
    public func listModules() -> [ModuleDescriptor] {
        return Array(modules.values)
    }
}
