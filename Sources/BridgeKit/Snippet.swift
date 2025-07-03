//
//  Snippet.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/Snippet.swift
//
//  Snippet.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Represents a reusable code snippet, storable and sharable.
//

import Foundation

public struct Snippet: Codable, Identifiable {
    /// Unique snippet id.
    public let id: String
    /// Human‐readable title.
    public var title: String
    /// The source code body.
    public var code: String
    /// Language identifier (e.g. "swift").
    public var language: String

    /// Create a snippet with auto‐generated ID.
    public init(
        id: String = UUID().uuidString,
        title: String,
        code: String,
        language: String
    ) {
        self.id = id
        self.title = title
        self.code = code
        self.language = language
    }
}
