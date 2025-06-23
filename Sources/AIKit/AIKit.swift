//
//  AIKit.swift
//  AIKit
//
//  Specification:
//  • Central registry for AI services in Tool.
//  • Exposes mentor, summarizer, and future AI utilities via static properties.
//
//  Discussion:
//  Bundling AI entry points under one namespace simplifies imports
//  and signals that these are core AI capabilities of Tool.
//
//  Rationale:
//  • Enforces consistency when adding new AI helpers.
//  • Avoids scattered singleton references across modules.
//
//  Dependencies: AIMentor
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum AIKit {
    /// Context-sensitive mentor.
    public static var mentor: AIMentor { AIMentor.shared }

    // Future expansions:
    // public static var summarizer: AISummarizer { ... }
}
