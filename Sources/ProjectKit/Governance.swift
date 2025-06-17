//
//  Governance.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Governance.swift
// ProjectKit — Governance rules engine for project policies.
//

import Foundation

/// Represents a project in your workspace.
public struct Project {
    public let id: UUID
    public let name: String
    // TODO: add other project metadata (owner, created date, etc.)
}

/// A governance rule that can validate a Project.
public struct GovernanceRule {
    public let id: UUID
    public let name: String
    public let description: String
    public let validate: (Project) -> Bool

    public init(
        id: UUID = .init(),
        name: String,
        description: String,
        validate: @escaping (Project) -> Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.validate = validate
    }
}

/// Actor to manage and evaluate governance rules.
public actor Governance {
    private var rules: [UUID: GovernanceRule] = [:]

    public init() {}

    /// Add a new rule.
    public func addRule(_ rule: GovernanceRule) {
        rules[rule.id] = rule
    }

    /// Remove a rule by its ID.
    public func removeRule(id: UUID) {
        rules.removeValue(forKey: id)
    }

    /// Evaluate all rules against a project, returning violations.
    public func evaluate(project: Project) -> [GovernanceRule] {
        return rules.values.filter { !($0.validate(project)) }
    }
}
