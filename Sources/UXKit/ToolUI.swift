//
//  ToolUI.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ToolUI.swift
// UXKit — Shared UI components & HUD overlays.
//
// Combines DominionHUD, GestureIndicatorOverlay, and other HUDs.
//

import SwiftUI

public struct ToolUI<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            content
            DominionHUD()
                .padding(.top, 10)
            GestureIndicatorOverlay()
        }
    }
}
