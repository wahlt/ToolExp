//
//  FacetEntity.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// FacetEntity.swift
// RepKit — Defines an Icon‐Facet model backing a UI slot.
//
// Each “facet” (UI icon) can be bound at runtime to a `RepStruct`,
// letting you hot‐swap content without rebuilding in Xcode.
//

import Foundation
import SwiftData

/// SwiftData model for a UI icon facet.
@Model
public class FacetEntity {
    /// Unique SwiftData ID for this facet slot.
    @Attribute(.unique) public var id: UUID
    /// Logical name (e.g. “BrushPalette”, “GravityForge”).
    public var name: String
    /// The backing RepStruct’s ID (in DataServ) for this facet.
    public var repBackingID: UUID?

    public init(
        id: UUID = .init(),
        name: String,
        repBackingID: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.repBackingID = repBackingID
    }
}
