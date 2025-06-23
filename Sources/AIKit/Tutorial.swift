//
//  Tutorial.swift
//  AIKit
//
//  Specification:
//  • Manages sequences of TutorialStep for interactive tutorials.
//  • Advances steps based on user actions.
//
//  Discussion:
//  Tutorials guide new users through core features. By modeling
//  each step as an immutable struct, we decouple UI from logic.
//
//  Rationale:
//  • Step IDs allow deep-linking/bookmarking progress.
//  • Action prompts can be checked by analytics or AI for hints.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct TutorialStep {
    public let id: String
    public let title: String
    public let description: String
    public let actionPrompt: String
}

public class TutorialManager {
    private(set) public var steps: [TutorialStep]
    private var index: Int = 0

    public init(steps: [TutorialStep]) {
        self.steps = steps
    }

    /// Returns current step, or nil if complete.
    public var current: TutorialStep? {
        guard steps.indices.contains(index) else { return nil }
        return steps[index]
    }

    /// Marks current step complete and advances.
    public func completeCurrent() {
        index += 1
    }

    /// Resets tutorial progress.
    public func reset() {
        index = 0
    }
}
