//
//  Decompose.swift
//  DataServ
//
//  Created by Flight Code on 2025-06-25.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Splits a RepStruct into subgraphs per node (basic partitioning).
//

import Foundation
import RepKit

public struct Decompose {
    /// For now, returns each node as its own single-node subgraph.
    public static func run(on graph: RepStruct) -> [[RepStruct]] {
        return graph.nodes.map { node in
            RepStruct(
                id: "\(graph.id)-\(node.id)",
                nodes: [node],
                ports: graph.ports.filter {
                    $0.fromCellID == node.id || $0.toCellID == node.id
                }
            )
        }
    }
}
