//
//  Relate.swift
//  DataServ
//
//  Specification:
//  • Creates lightweight edges between Persistable entities by ID.
//  • Returns a tuple (fromKey, toKey).
//
//  Discussion:
//  Rather than full graph objects, edges are simple ID pairs.
//  DataServ or GraphKit can consume these relations later.
//
//  Rationale:
//  • Decouples entity linking from storage logic.
//  • Easy to serialize or index in dictionaries.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum Relate {
    /// Links two Persistables, returning their storage keys.
    public static func link<T: Persistable, U: Persistable>(_ a: T, to b: U) -> (from: String, to: String) {
        return (from: T.storageKey, to: U.storageKey)
    }
}
