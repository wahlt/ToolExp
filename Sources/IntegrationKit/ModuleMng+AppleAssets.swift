//
//  ModuleMng+AppleAssets.swift
//  IntegrationKit
//
//  Specification:
//  • Extension to load module-specific assets from app bundle.
//  • Supports images, JSON, and shader files.
//
//  Discussion:
//  Kits with bundled resources can register their asset catalogs here.
//
//  Rationale:
//  • Avoids boilerplate Bundle lookups.
//  Dependencies: UIKit, Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import UIKit

public extension ModuleMng {
    /// Loads an image asset for the given module.
    func loadImage(_ name: String, inModule module: String) -> UIImage? {
        guard let bundle = Bundle(identifier: module) else { return nil }
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    /// Loads JSON text for the given module.
    func loadJSON(_ filename: String, inModule module: String) -> String? {
        guard let bundle = Bundle(identifier: module),
              let url = bundle.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        return try? String(contentsOf: url)
    }
}
