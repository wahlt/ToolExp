//
//  AgentSFX.swift
//  RenderKit
//
//  1. Purpose
//     Manages spatial audio effects for Agent views,
//     e.g. doppler, reverb, 3D positional panning.
//  2. Dependencies
//     AVFoundation, simd
//  3. Overview
//     Wraps AVAudioEngine with graph‐based DSP nodes.
//  4. Usage
//     Call `AgentSFX.shared.playSound(at:position:)`
//  5. Notes
//     Uses MPSGraph for FFT/reverb if available, CPU fallback.

import AVFoundation
import simd

public final class AgentSFX {
    public static let shared = AgentSFX()

    private let engine = AVAudioEngine()
    private let environment = AVAudioEnvironmentNode()
    private var players: [AVAudioPlayerNode] = []

    private init() {
        engine.attach(environment)
        engine.connect(environment, to: engine.mainMixerNode, format: nil)
        try? engine.start()
    }

    /// Plays a one-shot audio buffer at a given 3D position.
    public func playSound(
        buffer: AVAudioPCMBuffer,
        at position: SIMD3<Float>,
        volume: Float = 1.0
    ) {
        let player = AVAudioPlayerNode()
        players.append(player)
        engine.attach(player)
        engine.connect(player, to: environment, format: buffer.format)
        environment.listenerPosition = AVAudio3DPoint(x: 0, y: 0, z: 0)
        let point = AVAudio3DPoint(x: position.x, y: position.y, z: position.z)
        player.position = point
        player.volume = volume
        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: {
            // cleanup
            self.engine.detach(player)
            self.players.removeAll { $0 === player }
        })
        player.play()
    }
}
