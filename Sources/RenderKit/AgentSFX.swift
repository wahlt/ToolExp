//
//  AgentSFX.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AgentSFX.swift
// RenderKit — 3D/Audio effect wrapper for AI/Agent feedback.
//
// Responsibilities:
//  • Play brief particle, sound, or haptic feedback when an AI action occurs.
//  • Batch GPU commands for visual effects alongside the main render pass.
//

import Foundation
import MetalKit
import AVFoundation
import RepKit

/// Manages a shared pool of sound players and particle emitters.
public final class AgentSFX {
    /// Singleton access.
    public static let shared = AgentSFX()

    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var device: MTLDevice?
    private var commandQueue: MTLCommandQueue?

    private init() {
        // TODO: initialize Metal `device` & `commandQueue`
    }

    /// Play a short SFX by name (e.g. "ding", "error").
    public func playSound(named name: String) {
        if let player = audioPlayers[name] {
            player.play()
        } else if let url = Bundle.main.url(forResource: name, withExtension: "wav") {
            let player = try? AVAudioPlayer(contentsOf: url)
            audioPlayers[name] = player
            player?.play()
        }
    }

    /// Emit a brief particle effect at the given 3D position.
    public func emitParticles(
        name: String,
        at position: SIMD3<Float>,
        in view: MTKView
    ) {
        guard let queue = commandQueue else { return }
        let cmdBuf = queue.makeCommandBuffer()
        // TODO: encode particle compute or render pass here
        cmdBuf?.commit()
    }
}
