//
//  Decompose.swift
//  DataServ
//
//  Specification:
//  • Reflectively converts any instance into a dictionary via Mirror.
//  • Omits private or unsupported types.
//
//  Discussion:
//  For UI debugging and dynamic form editors, a generic
//  object-to-dictionary converter speeds prototyping.
//
//  Rationale:
//  • Mirror API is built-in and supports both Codable and non-Codable types.
//  • Clients can filter or transform values post hoc.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum Decompose {
    /// Uses Mirror to extract child labels and values.
    public static func entityToDict(_ value: Any) -> [String: Any] {
        var dict: [String: Any] = [:]
        let mirror = Mirror(reflecting: value)
        for child in mirror.children {
            guard let key = child.label else { continue }
            dict[key] = child.value
        }
        return dict
    }
}
