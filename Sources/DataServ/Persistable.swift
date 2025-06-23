//
//  Persistable.swift
//  DataServ
//
//  Protocol for models that can be stored and retrieved.
//  Conforming types must supply a `storageKey` and implement `save()`
//  to persist themselves.  The DataServ singleton will loadAll/saveAll
//  any `T: Persistable & Codable` by reading/writing JSON at
//  <baseURL>/<storageKey>.json.
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

/// Protocol for models that can be stored and retrieved.
public protocol Persistable: Sendable, Codable {
    /// Filename (without extension) for storage.
    static var storageKey: String { get }
}

/// Convenience default: allow a Persistable to save itself.
public extension Persistable {
    func save() throws {
        try DataServ.shared.saveAll([self], as: Self.self)
    }
}
