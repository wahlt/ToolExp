//
//  UXKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// UXKit.swift
// UXKit — Foundation for all Tool UI.
//
// Re-exports common types, environment keys, theme modifiers.
//

import SwiftUI

public extension View {
    /// Apply the standard Tool padding & background.
    func toolPanel() -> some View {
        self
            .padding(8)
            .background(Color(white: 0.95))
            .cornerRadius(6)
    }
}

// Environment key for the global theme color.
private struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

public extension EnvironmentValues {
    var toolThemeColor: Color {
        get { self[ThemeColorKey.self] }
        set { self[ThemeColorKey.self] = newValue }
    }
}
