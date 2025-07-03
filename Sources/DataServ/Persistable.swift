//
//  Persistable.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-23.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Protocol for types that can persist themselves.
//

import Foundation

public protocol Persistable {
    /// Saves the entity to persistent store.
    func save() throws

    /// Deletes the entity from persistent store.
    func delete() throws
}
