//
//  ModuleKit.swift
//  IntegrationKit
//
//  Defines the core Module protocol and a registration API
//  for dynamic, hot-loaded ToolExp modules.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Protocol every dynamic ToolExp module must implement.
public protocol Module {
    /// Unique identifier for this module.
    static var moduleID: String { get }

    /// Called immediately after the module is loaded.
    func didLoad()

    /// Called just before the module is unloaded.
    func willUnload()
}

/// Central registry for all loaded modules.
public enum ModuleKit {
    private static var registry: [String: Module] = [:]

    /// Registers a module instance and invokes its `didLoad()`.
    public static func register(_ module: Module) {
        let id = type(of: module).moduleID
        registry[id] = module
        module.didLoad()
    }

    /// Unregisters a module by ID and invokes its `willUnload()`.
    public static func unregister(moduleID id: String) {
        guard let module = registry[id] else { return }
        module.willUnload()
        registry.removeValue(forKey: id)
    }

    /// Retrieves a loaded module by its identifier.
    public static func module(withID id: String) -> Module? {
        return registry[id]
    }

    /// Lists all currently registered module IDs.
    public static func allModuleIDs() -> [String] {
        return Array(registry.keys)
    }
}
