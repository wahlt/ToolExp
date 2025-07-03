//
//  FacetEntity.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Models an interactive UI facet attached to a Cell.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Each facet has an ID, title, and an action closure.
//  4. Usage
//     Use FacetServ to fetch and display facets in the UI.
//  5. Notes
//     Actions run on main thread by default.

import Foundation

/// Represents an actionable UI facet on a Cell.
public struct FacetEntity: Identifiable {
    public let id: UUID
    public let title: String
    public let action: () -> Void

    /// Initializes a facet with title and action.
    public init(
        id: UUID = .init(),
        title: String,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.action = action
    }
}
