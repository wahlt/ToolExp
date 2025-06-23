//
//  FacetEntity.swift
//  RepKit
//
//  Specification:
//  • Represents a UI facet bound to a Rep cell or group.
//  • Holds icon, label, and interaction metadata.
//
//  Discussion:
//  Facets drive HUD overlays—e.g. “Traverse,” “Inspect,” etc.
//
//  Rationale:
//  • Decouple UI descriptors from core Rep data.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct FacetEntity: Codable, Equatable {
    public let id: UUID
    public let name: String
    public let iconName: String
    public let tooltip: String

    public init(name: String, iconName: String, tooltip: String) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.tooltip = tooltip
    }
}
