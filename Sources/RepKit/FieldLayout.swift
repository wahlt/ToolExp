//
//  FieldLayout.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  FieldLayout.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Defines presentation metadata for RepStruct fields.
//  2. Dependencies
//     Foundation
//  3. Overview
//     Holds field name, display label, default value.
//  4. Usage
//     UI bindings use FieldLayout to generate editors.
//  5. Notes
//     Default values wrapped in AnyCodable.

import Foundation

/// Describes how a field of RepStruct should be laid out in UI.
public struct FieldLayout: Codable {
    public let fieldName: String
    public let displayName: String
    public let defaultValue: AnyCodable

    /// Initializes layout info for a field.
    public init(
        fieldName: String,
        displayName: String,
        defaultValue: AnyCodable
    ) {
        self.fieldName = fieldName
        self.displayName = displayName
        self.defaultValue = defaultValue
    }
}
