//
//  ArchGestureRouter.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ArchGestureRouter.swift
// UXKit — Routes raw SwiftUI gestures through ArchGest.
//

import SwiftUI
import RepKit

public struct ArchGestureRouter: Gesture {
    public func body(configuration: Configuration) -> some Gesture {
        SimultaneousGesture(
            DragGesture(minimumDistance: 0),
            RotationGesture()
        )
        .onChanged { value in
            // Combine drag & rotation values if both present
            let touches = value.first?.numberOfTouches ?? 1
            let type = value.second != nil ? "Rotate" : "Drag"
            GestureIndicator.shared.type = type
            GestureIndicator.shared.touches = touches
            var params: [String: Any] = [
                "dx": value.first?.translation.width ?? 0,
                "dy": value.first?.translation.height ?? 0
            ]
            if let rot = value.second {
                params["angle"] = rot.degrees
            }
            GestureIndicator.shared.parameters = params.map { "\($0): \($1)" }.joined(separator: ", ")
            // TODO: hit-test, then ArchGest.interpret(...)
        }
        .onEnded { _ in
            GestureIndicator.shared.type = "None"
            GestureIndicator.shared.parameters = ""
        }
    }
}
