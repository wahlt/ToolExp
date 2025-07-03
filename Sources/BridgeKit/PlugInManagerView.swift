//
//  PlugInManagerView.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/PluginManagerView.swift
//
//  PluginManagerView.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  SwiftUI view listing available plugins.
//

import SwiftUI

public struct PluginManagerView: View {
    @State private var names: [String] = []

    public init() {
        // On init, capture current registry snapshot.
        self.names = PluginManager().registeredNames
    }

    public var body: some View {
        List(names, id: \.self) { name in
            Button(name) {
                _ = PluginManager().makePlugin(named: name)
            }
        }
    }
}
