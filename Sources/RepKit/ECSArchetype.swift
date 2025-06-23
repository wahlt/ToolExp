//
//  ECSArchetype.swift
//  RepKit
//
//  Specification:
//  • Group of entities matching a set of component types.
//  • Stores entity IDs sharing identical component signatures.
//
//  Discussion:
//  ECS (Entity-Component-System) pattern helps structure dynamic
//  Rep behaviors by component families.
//
//  Rationale:
//  • Rapid filtering of entities during system updates.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct ECSArchetype {
    public let componentKeys: Set<String>
    private(set) public var entityIDs: Set<UUID> = []

    public init(components: Set<String>) {
        self.componentKeys = components
    }

    /// Registers an entity with matching keys.
    public mutating func add(_ id: UUID) {
        entityIDs.insert(id)
    }

    /// Removes an entity.
    public mutating func remove(_ id: UUID) {
        entityIDs.remove(id)
    }

    /// Tests if archetype matches a given component set.
    public func matches(components: Set<String>) -> Bool {
        return componentKeys.isSubset(of: components)
    }
}
