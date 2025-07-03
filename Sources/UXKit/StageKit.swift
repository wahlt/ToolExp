//
//  StageKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  StageKit.swift
//  UXKit
//
//  1. Purpose
//     Defines `Stage` protocols and default views for RepStruct stages.
// 2. Dependencies
//     SwiftUI, RepKit, RenderKit
// 3. Overview
//     A `Stage` manages a `RepStruct` and renders it to a live canvas.
// 4. Usage
//     `StageKit.defaultView(for: rep)`
// 5. Notes
//     Supports plugging in custom `Stage` implementations.

import SwiftUI
import RepKit
import RenderKit

public protocol Stage {
    var rep: RepStruct { get }
    func makeView() -> AnyView
}

/// Provides the default “SuperStage” that simply renders via `RepRenderer`.
public struct StageKit {
    /// Returns a default stage view for a given rep.
    public static func defaultView(for rep: RepStruct) -> some View {
        DefaultStageView(rep: rep)
    }

    private struct DefaultStageView: View {
        let rep: RepStruct

        var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                RepRenderer().render(rep: rep)
            }
        }
    }
}
