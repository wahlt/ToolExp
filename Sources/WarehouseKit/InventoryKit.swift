//
//  InventoryKit.swift
//  WarehouseKit
//
//  1. Purpose
//     Manages collections of assets and links them to RepStruct cells.
// 2. Dependencies
//     Foundation, RepKit
// 3. Overview
//     Provides CRUD for asset inventories stored in a RepStruct.
// 4. Usage
//     `InventoryKit.shared.addAsset(...)`
// 5. Notes
//     Uses `RepStruct` ports/traits to annotate assets.

import Foundation
import RepKit

/// Service for managing asset inventories.
public final class InventoryKit {
    public static let shared = InventoryKit()
    private init() {}

    /// Add a named asset to the dominion.
    public func addAsset(name: String, to rep: inout RepStruct) {
        let cell = rep.addCell(name: name)
        // mark cell as asset type:
        rep.addTrait(AssetTrait.self, to: cell)
    }

    // other inventory methods …
}

/// Example trait—attachable to a cell representing an asset
public struct AssetTrait: Trait {
    public static var id: String { "com.toolexp.asset" }
}
