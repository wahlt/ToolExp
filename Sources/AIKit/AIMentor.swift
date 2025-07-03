// Sources/AIKit/AIMentor.swift
//
//  AIMentor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//
//  AIMentor — Interactive AI-driven tutorial and hint system.
//

import Foundation
import SwiftUI

/// ViewModel that drives the “mentor” panel in the AIKit tutorial.
@MainActor
public class AIMentor: ObservableObject {
    @Published public var history: [String] = []
    private let service: AIService

    public init(service: AIService = DefaultAIService()) {
        self.service = service
    }

    /// Sends the user’s input to the AI and appends the response to `history`.
    public func send(_ input: String) async {
        history.append("You: \(input)")
        do {
            let reply = try await service.complete(prompt: input, maxTokens: 150)
            history.append("Mentor: \(reply)")
        } catch {
            history.append("Error: \(error.localizedDescription)")
        }
    }
}
