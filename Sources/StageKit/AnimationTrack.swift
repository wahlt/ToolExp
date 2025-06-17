//
//  AnimationTrack.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AnimationTrack.swift
// StageKit — Represents a time-based track of parameter keyframes.
//
// Used for A/V timelines, ArtEngine asset animations, etc.
//

import Foundation

/// A single keyframe at a given time.
public struct Keyframe<Value: Equatable> {
    public let time: TimeInterval
    public let value: Value

    public init(time: TimeInterval, value: Value) {
        self.time = time
        self.value = value
    }
}

/// A track of keyframes for a single animatable parameter.
public struct AnimationTrack<Value: Equatable> {
    private var keyframes: [Keyframe<Value>] = []

    /// Add or replace a keyframe.
    public mutating func set(_ keyframe: Keyframe<Value>) {
        keyframes.removeAll { $0.time == keyframe.time }
        keyframes.append(keyframe)
        keyframes.sort { $0.time < $1.time }
    }

    /// Evaluate the track at a given time (linear interpolation).
    public func value(at time: TimeInterval) -> Value? {
        guard !keyframes.isEmpty else { return nil }
        // Exact match
        if let exact = keyframes.first(where: { $0.time == time }) {
            return exact.value
        }
        // Interpolate between surrounding frames
        let before = keyframes.filter { $0.time < time }.last
        let after  = keyframes.filter { $0.time > time }.first
        switch (before, after) {
        case (let b?, let a?):
            if let v0 = b.value as? Double,
               let v1 = a.value as? Double {
                let t0 = b.time, t1 = a.time
                let t  = (time - t0) / (t1 - t0)
                return ((v0 + (v1 - v0)*t) as? Value)
            }
            return b.value
        default:
            return before?.value ?? after?.value
        }
    }
}
