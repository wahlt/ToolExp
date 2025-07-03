//
//  ECSArchetype.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Defines archetype keys for efficient entity-component storage.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Holds component type names to group matching entities.
//  4. Usage
//     Use `matches(components:)` to filter entity pools.
//  5. Notes
//     Useful for batched operations on homogenous components.

import Foundation

/// Represents a set of component types in an archetype.
public struct ECSArchetype {
    public let components: [String]

    /// Initialize with component type names.
    public init(components: [String]) {
        self.components = components
    }

    /// Checks if given component keys satisfy this archetype.
    public func matches(components other: [String]) -> Bool {
        return Set(self.components).isSubset(of: Set(other))
    }
}
