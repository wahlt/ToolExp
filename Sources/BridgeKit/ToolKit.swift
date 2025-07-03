//
//  ToolKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/ToolKit.swift
//
//  ToolKit.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Helpers for low-level RepStruct manipulation.
//

import Foundation
import RepKit

public struct ToolKit: BridgeAdaptor {
    public static let name = "ToolKit"

    /// Returns all nodes carrying a particular trait in `rep`.
    /// - Parameters:
    ///   - traitType: The `Trait` subclass to filter by.
    ///   - rep:       The `RepStruct` container.
    public static func nodes<T: Trait>(
        withTrait traitType: T.Type,
        in rep: RepStruct
    ) -> [RepNode] {
        return rep.nodes.filter { node in
            node.traits.contains { type(of: $0) == traitType }
        }
    }

    /// Adds a new, empty node with given ID to `rep`.
    public static func addNode(
        id: String,
        to rep: inout RepStruct
    ) {
        rep.addNode(RepNode(id: id))
    }
}
