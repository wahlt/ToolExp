//
//  CRDTRepMergeService.swift
//  ContinuityKit
//
// 1. Purpose
//    Merge CRDT deltas into a local RepStruct.
// 2. Dependencies
//    Foundation, RepKit
// 3. Overview
//    Uses RepKit to decode and integrate remote changes.

import Foundation
import RepKit

public final class CRDTRepMergeService {
    /// Merge a remote delta (JSON‐encoded RepStruct) into `rep`.
    public func merge(rep: inout RepStruct, delta: Data) throws {
        let other = try JSONDecoder().decode(RepStruct.self, from: delta)
        rep.merge(other)
    }
}
