// File: Sources/IntegrationKit/ModuleMng+AppleAssets.swift
//  IntegrationKit
//
//  Specification:
//  • Extension on ModuleMng to load Apple-specific asset‐catalog images and colors
//    when running on UIKit platforms.
//
//  Discussion:
//  We wrap `import UIKit` and the extension methods in `#if canImport(UIKit)` guards
//  so that this file compiles cleanly on macOS, visionOS, and any non-UIKit environment.
//
//  Rationale:
//  • Prevents “no such module 'UIKit'” errors on non-iOS/tvOS targets.
//  • Keeps asset-loading logic decoupled from core business logic in ModuleMng.
//
//  TODO:
//  • Cache loaded UIImages/UIColor instances for performance.
//  • Provide SF Symbol fallbacks for missing assets.
//  • Add unit tests that stub UIImage/UIColor for non-UIKit platforms.
//
//  Dependencies: Foundation, UIKit (iOS/tvOS only)
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public extension ModuleMng {
    #if canImport(UIKit)
    /// Returns the module’s icon image from the asset catalog, or nil if not found.
    /// - Parameter name: The registered module name.
    static func icon(forModule name: String) -> UIImage? {
        return UIImage(named: "\(name)_icon")
    }

    /// Returns the module’s theme color from the asset catalog, or nil if not found.
    /// - Parameter name: The registered module name.
    static func color(forModule name: String) -> UIColor? {
        return UIColor(named: "\(name)_color")
    }
    #endif
}
