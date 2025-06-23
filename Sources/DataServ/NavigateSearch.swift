//
//  NavigateSearch.swift
//  DataServ
//
//  Specification:
//  • Performs case-insensitive substring search on string arrays.
//  • Returns items containing the query.
//
//  Discussion:
//  Basic search UI uses this helper to filter lists on keystrokes.
//  More advanced fuzzy search can build on top of this API.
//
//  Rationale:
//  • Keeps search logic out of ViewControllers.
//  • Ensures consistent behavior across Tool.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum NavigateSearch {
    /// Filters strings array by query substring (CI).
    public static func strings(_ items: [String], matching query: String) -> [String] {
        let q = query.lowercased()
        return items.filter { $0.lowercased().contains(q) }
    }
}
