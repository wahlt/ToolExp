//
//  AgentSFX.swift
//  RenderKit
//
//  Specification:
//  • Audio-visual special effects for the AI Agent persona.
//  • Uses AVFoundation for sounds and UIKit for haptics.
//
//  Discussion:
//  Agent interactions benefit from audio cues and subtle haptics.
//
//  Rationale:
//  • Keep SFX logic isolated for easy replacement of assets.
//  Dependencies: AVFoundation, UIKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public class AgentSFX {
    private var player: AVAudioPlayer?

    /// Plays a named sound file from the bundle.
    public func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else { return }
        DispatchQueue.global().async {
            self.player = try? AVAudioPlayer(contentsOf: url)
            self.player?.play()
        }
    }

    /// Triggers a light haptic impact.
    public func hapticLight() {
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.impactOccurred()
    }
}
