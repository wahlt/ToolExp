//
//  FacetServ.swift
//  ServiceKit
//
//  Specification:
//  • Registers and retrieves available FacetEntity instances.
//  • Caches icon images for fast HUD rendering.
//
//  Discussion:
//  HUDOverlayManager queries FacetServ for facets to display.
//  Preloading icons reduces flicker.
//
//  Rationale:
//  • Central registry simplifies facet management across SuperStages.
//  • UIImage cache avoids redundant disk loads.
//
//  Dependencies: UIKit, RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import UIKit
import RepKit

public class FacetServ {
    public static let shared = FacetServ()
    private var facets:    [UUID: FacetEntity] = [:]
    private var iconCache: [String: UIImage]  = [:]

    private init() {}

    /// Registers a new facet.
    public func register(_ facet: FacetEntity) {
        facets[facet.id] = facet
    }

    /// Returns all registered facets.
    public func allFacets() -> [FacetEntity] {
        return Array(facets.values)
    }

    /// Loads or returns cached icon for a facet.
    public func icon(for facet: FacetEntity) -> UIImage? {
        if let img = iconCache[facet.iconName] { return img }
        let img = UIImage(named: facet.iconName)
        iconCache[facet.iconName] = img
        return img
    }
}
