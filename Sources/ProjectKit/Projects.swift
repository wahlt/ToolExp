//
//  Projects.swift
//  ProjectKit
//
//  1. Purpose
//     Lifecycle management for projects.
// 2. Dependencies
//     Foundation, RepKit
// 3. Overview
//     Singleton exposes create/open/close.
// 4. Usage
//     `let rep = ProjectService.shared.create(name:)`.

import Foundation
import RepKit

@MainActor
public final class ProjectService {
    public static let shared = ProjectService()
    private init() {}

    /// Create a new project with the given name.
    public func create(name: String) -> RepStruct {
        var rep = RepStruct()
        rep.metadata["projectName"] = .string(name)
        return rep
    }

    // … other project methods …
}
