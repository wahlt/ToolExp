//
//  AutomataDSL.swift
//  EngineKit
//
//  Specification:
//  • Fluent API for defining finite-state machines.
//  • Builds a lightweight StateMachine struct.
//
//  Discussion:
//  Automata model typical workflows: tutorial steps, UI states,
//  or custom DSL-driven processes within Tool.
//
//  Rationale:
//  • DSL closure chaining improves readability.
//  • Generated StateMachine can be persisted or inspected.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public class AutomataDSL {
    private var states: [String] = []
    private var transitions: [(from: String, to: String, event: String)] = []

    /// Adds a new state to the machine.
    @discardableResult
    public func state(_ name: String) -> AutomataDSL {
        if !states.contains(name) {
            states.append(name)
        }
        return self
    }

    /// Adds a transition triggered by an event.
    @discardableResult
    public func transition(from: String, to: String, on event: String) -> AutomataDSL {
        transitions.append((from: from, to: to, event: event))
        return self
    }

    /// Compiles the DSL into a `StateMachine`.
    public func build() -> StateMachine {
        return StateMachine(states: states, transitions: transitions)
    }
}

public struct StateMachine {
    public let states: [String]
    public let transitions: [(from: String, to: String, event: String)]

    /// Fires an event from the current state, returns next state.
    public func fire(event: String, from current: String) -> String? {
        return transitions.first {
            $0.from == current && $0.event == event
        }?.to
    }
}
