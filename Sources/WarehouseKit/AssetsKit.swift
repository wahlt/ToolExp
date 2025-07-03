//
//  AssetKit.swift
//  WarehouseKit
//
//  1. Purpose
//     High-level asset management: images, audio, etc.
// 2. Dependencies
//     Foundation, UIKit/AppKit
// 3. Overview
//     Wraps platform APIs to load and cache assets.
// 4. Usage
//     `let img = AssetKit.shared.loadImage(named: "foo")`
// 5. Notes
//     Conditionally imports UIKit or AppKit.

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Centralized asset loading and caching.
public final class AssetKit {
    public static let shared = AssetKit()
    private init() {}

    /// Load an image by name from the main bundle.
    public func loadImage(named name: String) -> PlatformImage? {
        #if canImport(UIKit)
        return UIImage(named: name)
        #elseif canImport(AppKit)
        return NSImage(named: name)
        #else
        return nil
        #endif
    }

    /// Platform-neutral image typealias.
    #if canImport(UIKit)
    public typealias PlatformImage = UIImage
    #elseif canImport(AppKit)
    public typealias PlatformImage = NSImage
    #endif
}
