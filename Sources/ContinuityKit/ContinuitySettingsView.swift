//
//  ContinuitySettingsView.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/ContinuitySettingsView.swift
//
//  ContinuitySettingsView.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  SwiftUI form for toggling Continuity sync options.

import SwiftUI

public struct ContinuitySettingsView: View {
    @AppStorage("syncEnabled") private var enabled: Bool = true
    @AppStorage("syncEndpoint") private var endpoint: String = ""

    public init() {}

    public var body: some View {
        Form {
            Toggle("Enable Sync", isOn: $enabled)
            TextField("Endpoint URL", text: $endpoint)
        }
        .padding()
    }
}
