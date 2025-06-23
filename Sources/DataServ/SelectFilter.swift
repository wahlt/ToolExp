//
//  SelectFilter.swift
//  DataServ
//
//  Specification:
//  • Provides generic map and filter for arrays.
//  • Wraps standard sequence operations for uniform API.
//
//  Discussion:
//  Having these helpers reduces boilerplate in UI code where
//  one-liners can be concise and readable.
//
//  Rationale:
//  • Encourages use of functional collection transforms.
//  • Maintains a single import point for common utilities.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum SelectFilter {
    /// Filters an array by predicate.
    public static func filter<T>(_ items: [T], by predicate: (T) -> Bool) -> [T] {
        return items.filter(predicate)
    }

    /// Maps an array through transform.
    public static func map<T, U>(_ items: [T], to transform: (T) -> U) -> [U] {
        return items.map(transform)
    }
}
