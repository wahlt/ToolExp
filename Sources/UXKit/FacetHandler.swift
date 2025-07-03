//
//  FacetHandler.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  FacetHandler.swift
//  UXKit
//
//  1. Purpose
//     Protocol and default implementation for UI facet handlers.
// 2. Dependencies
//     SwiftUI, Combine
// 3. Overview
//     Defines how to handle facet events and state.
// 4. Usage
//     Conform your own handler to customize behavior.
// 5. Notes
//     Each handler may provide a SwiftUI view.

import SwiftUI
import Combine

/// Represents a UI facet (tool icon, panel, etc.).
public struct Facet {
    public let id: String
    public let icon: Image
    public let title: String
}

/// Protocol for any facet’s logic and view.
public protocol FacetHandler {
    /// The facet this handler supports.
    static var facet: Facet { get }

    /// Returns the view for this facet.
    func makeView() -> AnyView

    /// Reacts to the facet being selected.
    func didSelect()
}

/// Registry of all available facet handlers.
public final class FacetRegistry {
    private var handlers: [String: FacetHandler] = [:]

    /// Registers a handler instance.
    public func register(_ handler: FacetHandler) {
        handlers[type(of: handler).facet.id] = handler
    }

    /// Returns the handler for a given facet ID.
    public func handler(for id: String) -> FacetHandler? {
        handlers[id]
    }

    /// All registered facet descriptors.
    public var allFacets: [Facet] {
        handlers.values.map { type(of: $0).facet }
    }
}
