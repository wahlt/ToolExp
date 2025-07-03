//
//  DataProcessor.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  DataProcessor.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-23.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Pure-CPU fallback for data transformations not yet GPU-accelerated.
//

import Foundation

public struct DataProcessor {
    /// Applies a CPU-based map over an array of values.
    public static func map<T, U>(_ array: [T], using transform: (T) -> U) -> [U] {
        return array.map(transform)
    }

    /// Reduces an array of values on the CPU.
    public static func reduce<T>(_ array: [T], initial: T, using combine: (T, T) -> T) -> T {
        return array.reduce(initial, combine)
    }
}
