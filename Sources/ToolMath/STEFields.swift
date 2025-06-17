//
//  STEFields.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// STEFields.swift
// ToolMath — Placeholder for specialized field types.
//
// Algebraic, Geometric, Analytic, Numeric, TensorNetworks, etc.
// Each case could map to a specialized solver or GPU kernel.
//

import Foundation

public enum STEField {
    case algebraic
    case geometric
    case analytic
    case numeric
    case tensorNetwork
    case probability
    case groupTheory
    case fluids
    case electromagnetism
    case generalRelativity
    case quantumMechanics

    /// Returns a human-readable description.
    public var description: String {
        switch self {
        case .algebraic: return "Algebraic"
        case .geometric: return "Geometric"
        case .analytic: return "Analytic"
        case .numeric:  return "Numeric"
        case .tensorNetwork: return "Tensor Network"
        case .probability:   return "Probability"
        case .groupTheory:   return "Group Theory"
        case .fluids:        return "Fluid Dynamics"
        case .electromagnetism: return "Electromagnetism"
        case .generalRelativity: return "General Relativity"
        case .quantumMechanics:  return "Quantum Mechanics"
        }
    }
}
