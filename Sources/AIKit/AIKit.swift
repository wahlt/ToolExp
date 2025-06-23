// File: AIKit/AIKit.swift
//
//  AIKit.swift
//  AIKit
//
//  Specification:
//  • Central registry for AI services in Tool.
//  • Uses protocol-based injection for mentor.
//
//  Discussion:
//  When writing tests or swapping AI backends, simply assign
//  `AIKit.mentor = MyMockMentor()` before launching the UI.
//
//  Rationale:
//  • Testable, replaceable without changing callers.
//  Dependencies: AIMentorProtocol
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum AIKit {
    /// The current global Mentor instance.
    public static var mentor: AIMentorProtocol {
        get { AIMentor.shared }
        set {
            if let m = newValue as? AIMentor {
                AIMentor.shared = m
            }
        }
    }
}
