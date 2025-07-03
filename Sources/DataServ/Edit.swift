//
//  Edit.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-23.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Applies versioned edits to data entities, with undo support.
//

import Foundation
import SwiftData

public struct DataChange {
    public let description: String
}

public struct Edit {
    /// Applies a change operation and registers undo.
    public static func apply(change: DataChange, in context: ModelContext) throws {
        let um = context.undoManager ?? UndoManager()
        um.beginUndoGrouping()
        // decode `change.description` into real operations...
        um.endUndoGrouping()
        try context.save()
    }
}
