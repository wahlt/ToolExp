//
//  SettingsEntity.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// SettingsEntity.swift
// ServiceKit — SwiftData @Model for app-wide preferences & feature flags.
//

import SwiftData
import Foundation

@Model
public class SettingsEntity {
    @Attribute(.unique) public var key: String
    public var boolValue: Bool?
    public var intValue: Int?
    public var stringValue: String?

    public init(key: String,
                bool: Bool? = nil,
                int: Int? = nil,
                string: String? = nil) {
        self.key = key
        self.boolValue   = bool
        self.intValue    = int
        self.stringValue = string
    }
}
