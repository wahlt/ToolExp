//
//  Traverse.swift
//  DataServ
//
//  Specification:
//  • Implements pre-order traversal for tree-like structures.
//  • Accepts a closure to visit each node exactly once.
//
//  Discussion:
//  Useful for flattening Rep trees or UI component hierarchies.
//  Recursion depth must be considered for very deep graphs.
//
//  Rationale:
//  • Pre-order yields parent before children, matching many UI layouts.
//  • General-purpose to accept any node type via children() closure.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum Traverse {
    /// Recursively traverses nodes in pre-order.
    ///
    /// - Parameters:
    ///   - root: The starting node.
    ///   - children: Closure to obtain child nodes.
    ///   - visit: Called for each visited node.
    public static func preOrder<T>(_ root: T,
                                   children: (T) -> [T],
                                   visit: (T) -> Void) {
        visit(root)
        for child in children(root) {
            preOrder(child, children: children, visit: visit)
        }
    }
}
