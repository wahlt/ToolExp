//
//  Tutorial.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Tutorial.swift
// AIKit — In-app guided tutorial flows.
//
// Defines a sequence of tutorial steps that can be advanced or replayed.
//

import Foundation

/// A single tutorial step.
public struct TutorialStep {
    /// Unique identifier for the step.
    public let id: String
    /// The title shown to the user.
    public let title: String
    /// Detailed instruction text.
    public let instruction: String
    /// Optional predicate to check completion.
    public let completionCheck: () -> Bool
}

/// The tutorial manager actor.
public actor TutorialManager {
    private var steps: [TutorialStep]
    private var currentIndex: Int = 0

    /// Initialize with a list of steps.
    public init(steps: [TutorialStep]) {
        self.steps = steps
    }

    /// Get the current tutorial step.
    public func currentStep() -> TutorialStep? {
        guard currentIndex < steps.count else { return nil }
        return steps[currentIndex]
    }

    /// Advance to the next step if the current is complete.
    public func advanceIfNeeded() {
        guard let step = currentStep(),
              step.completionCheck()
        else { return }
        currentIndex += 1
    }

    /// Reset the tutorial back to the first step.
    public func reset() {
        currentIndex = 0
    }
}
