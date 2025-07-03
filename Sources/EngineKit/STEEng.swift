//
//  STEEng.swift
//  EngineKit
//
//  SwiftUI view and service for selecting compute precision.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import SwiftUI
import RepKit

/// UI for choosing tensor-compute precision (fp16/fp32/fp64).
public struct STEEngView: View {
    @AppStorage("precisionMode") private var storedMode: String = Precision.fp32.rawValue
    @State private var precision: Precision = .fp32

    public init() {
        _precision = State(initialValue: Precision(rawValue: storedMode) ?? .fp32)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Compute Precision")
                .font(.headline)
            Picker("Precision", selection: $precision) {
                ForEach(Precision.allCases) { mode in
                    Text(mode.description).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: precision) { newMode in
                storedMode = newMode.rawValue
                EnginePrecisionService.shared.currentPrecision = newMode
            }
        }
        .padding()
    }
}

/// Broadcasts the current precision choice to all subsystems.
public final class EnginePrecisionService {
    public static let shared = EnginePrecisionService()

    /// The active precision mode.
    public var currentPrecision: Precision {
        didSet {
            NotificationCenter.default.post(
                name: .precisionModeDidChange,
                object: currentPrecision
            )
        }
    }

    private init() {
        let raw = UserDefaults.standard.string(forKey: "precisionMode") ?? Precision.fp32.rawValue
        currentPrecision = Precision(rawValue: raw) ?? .fp32
    }
}

public extension Notification.Name {
    /// Posted when compute precision changes.
    static let precisionModeDidChange = Notification.Name("EnginePrecisionService.precisionModeDidChange")
}
