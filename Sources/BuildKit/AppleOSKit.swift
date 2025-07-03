// Sources/BuildKit/AppleOSKit.swift
//
// Provides a BridgeAdaptor that connects to the host Apple OS APIs
// so that PluginManager can discover system-level scripting hooks.

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#else
#error("AppleOSKit is only supported on Apple platforms")
#endif

/// Conforms to `BridgeAdaptor`, allowing BridgeKit to load
/// OS-specific adaptors by name.
public struct AppleOSKit: BridgeAdaptor {
    /// Bridge name used in PluginManager registrations
    public static let name = "AppleOS"

    /// Perform any OS-specific initialization here.
    public init() {
        // e.g. register for notifications or service lookups
    }
}
