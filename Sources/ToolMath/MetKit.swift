//
//  MetKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// MetKit.swift
// ToolMath — Meta-introspection & schema utilities.
//
// Helpers to reflect on data structures, derive field lists, etc.
//

import Foundation

/// Protocol for types that can describe their own fields.
public protocol Reflectable {
    /// Keys and values of self at runtime.
    func reflect() -> [String: Any]
}

public extension Reflectable {
    func reflect() -> [String: Any] {
        // Use Mirror for default behavior.
        let mirror = Mirror(reflecting: self)
        var dict: [String: Any] = [:]
        for child in mirror.children {
            if let label = child.label {
                dict[label] = child.value
            }
        }
        return dict
    }
}
