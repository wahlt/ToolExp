//
//  TrackMixer.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// TrackMixer.swift
// StageKit — Mix multiple AnimationTracks into a single timeline.
//

import Foundation

/// Given multiple tracks controlling the same parameter,
/// blends their values by weighted summation.
public struct TrackMixer<Value: Equatable> {
    private var tracks: [(track: AnimationTrack<Value>, weight: Double)] = []

    /// Add a track with a blending weight (0…1).
    public mutating func add(_ track: AnimationTrack<Value>, weight: Double) {
        tracks.append((track, weight))
    }

    /// Evaluate the mixed value at time `t`.
    public func value(at time: TimeInterval) -> Value? {
        // For scalar Double, compute weighted average.
        var total: Double = 0
        var sumWeight: Double = 0
        for (track, w) in tracks {
            if let v = track.value(at: time) as? Double {
                total += v * w
                sumWeight += w
            }
        }
        if sumWeight > 0 {
            return (total / sumWeight) as? Value
        }
        // Fallback: return from first non-nil track
        for (track, _) in tracks {
            if let v = track.value(at: time) {
                return v
            }
        }
        return nil
    }
}
