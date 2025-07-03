//
//  ContinuitySettings.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/ContinuitySettings.swift
//
//  ContinuitySettings.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  User defaults for Continuity sync behaviors.

import Foundation

public struct ContinuitySettings {
    @UserDefault("syncEnabled", defaultValue: true)
    public static var syncEnabled: Bool

    @UserDefault("syncEndpoint", defaultValue: "wss://sync.example.com")
    public static var syncEndpoint: String
}

@propertyWrapper
public struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    public init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value
                ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
