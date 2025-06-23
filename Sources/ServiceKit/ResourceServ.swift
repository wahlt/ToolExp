//
//  ResourceServ.swift
//  ServiceKit
//
//  Specification:
//  • Centralized access to bundled assets: images, shaders, help files.
//  • Provides localized string lookups.
//
//  Discussion:
//  Avoid scattering Bundle.main lookups across modules.
//
//  Rationale:
//  • Single API for asset retrieval.
//  • Facilitates unit testing by mocking ResourceServ.
//
//  Dependencies: Foundation, UIKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import UIKit

public class ResourceServ {
    public static let shared = ResourceServ()
    private init() {}

    /// Loads an image from the main bundle.
    public func image(named: String) -> UIImage? {
        return UIImage(named: named)
    }

    /// Loads a .metal shader source file.
    public func shaderSource(named: String) -> String? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "metal") else {
            return nil
        }
        return try? String(contentsOf: url)
    }

    /// Returns a localized string.
    public func localized(_ key: String, table: String? = nil) -> String {
        return NSLocalizedString(key, tableName: table, bundle: .main, comment: "")
    }
}

