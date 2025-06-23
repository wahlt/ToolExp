//
//  Governance.swift
//  ProjectKit
//
//  Specification:
//  • Defines project governance policies: access roles, permissions.
//  • Provides evaluation of policy compliance.
//
//  Discussion:
//  Projects may have multiple collaborators with varied roles.
//  Governance ensures only authorized edits or launches.
//
//  Rationale:
//  • Centralize policy logic rather than scattering across UI.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum ProjectRole: String, Codable {
    case owner, editor, viewer
}

public struct Governance {
    /// Checks if a user with a given role can perform an action.
    public static func canPerform(role: ProjectRole, action: String) -> Bool {
        switch (role, action) {
        case (.owner, _):                return true
        case (.editor, "edit"), (.editor, "view"):  return true
        case (.viewer, "view"):          return true
        default:                         return false
        }
    }
}
