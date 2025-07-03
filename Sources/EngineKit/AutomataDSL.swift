//
//  AutomataDSL.swift
//  EngineKit
//
//  A minimal domain-specific language (DSL) for simple state
//  machine scripts: move, wait, and callback instructions.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import simd

/// Single instruction for the automata DSL.
public enum AutomataInstruction {
    /// Move an entity to `position` over `duration` seconds.
    case move(to: SIMD3<Float>, duration: Float)
    /// Pause execution for `duration` seconds.
    case wait(duration: Float)
    /// Execute custom code callback on RepStruct.
    case callback((inout RepStruct) -> Void)
}

/// Parser for the AutomataDSL textual script.
public final class AutomataDSL {
    /// Parses a script where each line is:
    ///   - `move x y z t`
    ///   - `wait t`
    ///   - `callback` lines not supported in text form.
    public static func parse(_ script: String) -> [AutomataInstruction] {
        var instructions: [AutomataInstruction] = []
        for line in script.split(separator: "\n") {
            let parts = line.trimmingCharacters(in: .whitespaces).split(separator: " ")
            guard let cmd = parts.first else { continue }

            switch cmd {
            case "move" where parts.count == 5:
                if let x = Float(parts[1]),
                   let y = Float(parts[2]),
                   let z = Float(parts[3]),
                   let t = Float(parts[4]) {
                    instructions.append(.move(to: SIMD3(x, y, z), duration: t))
                }
            case "wait" where parts.count == 2:
                if let t = Float(parts[1]) {
                    instructions.append(.wait(duration: t))
                }
            default:
                // Unknown line -> skip
                continue
            }
        }
        return instructions
    }
}
