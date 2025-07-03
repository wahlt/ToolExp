//
//  Traverse.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-25.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Provides graph traversal utilities for Rep-based structures.
//

import Foundation
import RepKit

public struct Traverse {
    /// Depth-first traversal starting at root RepStruct.
    public static func depthFirst(_ rep: RepStruct, visit: (RepStruct) -> Void) {
        visit(rep)
        for node in rep.nodes {
            let sub = RepStruct(id: node.id,
                                nodes: [node],
                                ports: rep.ports.filter {
                                    $0.fromCellID == node.id || $0.toCellID == node.id
                                })
            depthFirst(sub, visit: visit)
        }
    }
}
