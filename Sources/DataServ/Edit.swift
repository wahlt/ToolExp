//
//  Edit.swift
//  DataServ
//
//  Specification:
//  • Applies an inout mutation to a copy of a value and returns it.
//  • Allows functional-style updates of immutable structs.
//
//  Discussion:
//  Immutable data models benefit from copy-on-write mutations.
//  This helper avoids boilerplate “var x = original; mutate; return x.”
//
//  Rationale:
//  • Encourages value-type usage.
//  • Simplifies code that transforms model instances.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum Edit {
    /// Returns a mutated copy of the original value.
    public static func mutated<T>(_ original: T, using block: (inout T) -> Void) -> T {
        var copy = original
        block(&copy)
        return copy
    }
}
