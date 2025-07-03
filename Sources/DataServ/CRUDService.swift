//
//  CRUDService.swift
//  DataServ
//
// 1. Purpose
//    Provides generic Create, Read, Update, Delete operations for SwiftData models.
// 2. Dependencies
//    Foundation, SwiftData
// 3. Overview
//    Wraps SwiftData’s ModelContext for ergonomic CRUD usage.

import Foundation
import SwiftData

public class CRUDService<Model> {
    /// The SwiftData context used for all operations.
    private let context: ModelContext

    /// Initialize with an optional custom context (default is `.shared`).
    public init(context: ModelContext = .shared) {
        self.context = context
    }

    /// Create a new instance of `Model`, configure it via the `build` closure, then save.
    ///
    /// - Parameter build: Closure that accepts an `inout Model` to set its initial state.
    /// - Returns: The newly created and persisted model.
    @discardableResult
    public func create(_ build: (inout Model) -> Void) -> Model where Model: Codable {
        var instance = Model()           // Assumes `Model` is default‐constructible.
        build(&instance)
        context.insert(instance)         // Insert into SwiftData context.
        context.save()                   // Persist changes.
        return instance
    }

    /// Fetch all existing instances of `Model`.
    ///
    /// - Returns: Array of all `Model` objects in the store.
    public func readAll() -> [Model] where Model: Codable {
        return context.fetch(Model.self)
    }

    /// Update an existing model by applying `modify`, then save.
    ///
    /// - Parameters:
    ///   - instance: The model to update.
    ///   - modify: Closure that mutates the model’s properties.
    public func update(_ instance: Model, modify: (inout Model) -> Void) where Model: Codable {
        var copy = instance
        modify(&copy)
        context.save()
    }

    /// Delete the given model from the context and save.
    ///
    /// - Parameter instance: The model to delete.
    public func delete(_ instance: Model) {
        context.delete(instance)
        context.save()
    }
}
