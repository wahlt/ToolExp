//
//  Evaluate.swift
//  InvestigateKit
//
// 1. Purpose
//    Evaluate JavaScript code in a shared context.
// 2. Dependencies
//    Foundation, JavaScriptCore
// 3. Overview
//    Wraps JSContext for safe script execution.

import Foundation
@preconcurrency import JavaScriptCore

public struct Evaluate {
    /// Shared JS context; JSContext is not Sendable.
    private static let jsContext: JSContext = {
        let ctx = JSContext()!
        ctx.exceptionHandler = { _, exception in
            // handle exceptions…
        }
        return ctx
    }()

    /// Execute JS string and return `String?`.
    public static func run(js: String) -> String? {
        return jsContext.evaluateScript(js)?.toString()
    }
}
