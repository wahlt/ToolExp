//
//  Investigate.swift
//  InvestigateKit
//
//  Entry-point for reflection-based inspection of Swift values.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct Investigate {
    /// Recursively prints the properties of any value.
    public static func dump<T>(_ value: T) {
        _dump(Mirror(reflecting: value), indent: "")
    }

    private static func _dump(_ mirror: Mirror, indent: String) {
        for child in mirror.children {
            if let label = child.label {
                print("\(indent)\(label): \(child.value)")
                let childMirror = Mirror(reflecting: child.value)
                if !childMirror.children.isEmpty {
                    _dump(childMirror, indent: indent + "  ")
                }
            }
        }
    }
}
