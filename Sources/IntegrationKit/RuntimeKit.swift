//
//  RuntimeKit.swift
//  IntegrationKit
//
//  Manages named runtime contexts for module execution.
//  Modules can store and retrieve arbitrary shared services.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Holds a collection of shared services for runtime modules.
public struct RuntimeContext {
    /// Dictionary of services keyed by string identifiers.
    public let services: [String: Any]

    public init(services: [String: Any] = [:]) {
        self.services = services
    }
}

/// Registry of named RuntimeContext instances.
public enum RuntimeKit {
    private static var contexts: [String: RuntimeContext] = [:]

    /// Sets or replaces the context for `name`.
    public static func setContext(_ context: RuntimeContext, forName name: String) {
        contexts[name] = context
    }

    /// Removes the context associated with `name`.
    public static func removeContext(forName name: String) {
        contexts.removeValue(forKey: name)
    }

    /// Retrieves the context for `name`, if any.
    public static func context(forName name: String) -> RuntimeContext? {
        return contexts[name]
    }
}//
//  RuntimeKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

