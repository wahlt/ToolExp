// Sources/MLXRepKit/TensorGraphRegistry.swift
//
// Central registry for caching and reusing MPSGraph pipelines.
// Implements a thread-safe LRU eviction policy to bound memory.

import Foundation
import MetalPerformanceShadersGraph

/// Registry key includes operation type, shape, and precision.
/// Entry count is bounded; oldest entries evicted first.
public final class TensorGraphRegistry {
    /// Shared singleton, thread-safe access.
    public static let shared = TensorGraphRegistry()
    private init() {}

    /// Cache entry bundles the graph and its IO tensors.
    private struct Entry {
        let graph: MPSGraph
        let inputs: [MPSGraphTensor]
        let outputs: [MPSGraphTensor]
    }

    private var cache: [String: Entry] = [:]
    private var usage: [String] = []
    private let lock = DispatchQueue(label: "TensorGraphRegistry.lock", attributes: .concurrent)
    private let maxEntries = 128

    /// Record a cache hit to update LRU order.
    private func recordUsage(_ key: String) {
        lock.async(flags: .barrier) {
            self.usage.removeAll { $0 == key }
            self.usage.insert(key, at: 0)
            if self.usage.count > self.maxEntries {
                let evicted = self.usage.removeLast()
                self.cache.removeValue(forKey: evicted)
            }
        }
    }

    /// Fetch a cached entry if present.
    private func fetch(_ key: String) -> Entry? {
        return lock.sync { cache[key] }
    }

    /// Key generator for 1D gradient graphs.
    private func keyForGrad1D(n: Int, Δ: Float, precision: Precision) -> String {
        // Format the step-size to fixed precision to avoid floating-point mismatches.
        let d = String(format: "%.6f", Δ)
        return "grad1D:\(n):\(d):\(precision.rawValue)"
    }

    /// Returns a graph that computes the central-difference 1D gradient
    /// on an array of length `n` with step `Δ`, in the given `precision`.
    public func gradient1DGraph(
        length n: Int,
        Δ: Float = 1.0,
        precision: Precision = .fp32
    ) -> (graph: MPSGraph, input: MPSGraphTensor, output: MPSGraphTensor) {
        let key = keyForGrad1D(n: n, Δ: Δ, precision: precision)
        if let e = fetch(key) {
            recordUsage(key)
            return (e.graph, e.inputs[0], e.outputs[0])
        }

        // Build a new MPSGraph pipeline for the three-point stencil.
        let graph = MPSGraph()
        let shape = [NSNumber(value: n)]
        let IN = graph.placeholder(shape: shape,
                                   dataType: precision.dataType,
                                   name: key + "_in")
        let weights: [Float] = [-0.5/Δ, 0.0, 0.5/Δ]
        let KER = graph.constant(weights,
                                 shape: [3],
                                 dataType: precision.dataType,
                                 name: key + "_ker")
        let OUT = graph.convolution1D(IN,
                                      weights: KER,
                                      strides: [1],
                                      paddingLeft: [1],
                                      paddingRight: [1],
                                      name: key + "_out")

        // Cache and return.
        let entry = Entry(graph: graph, inputs: [IN], outputs: [OUT])
        lock.async(flags: .barrier) {
            self.cache[key] = entry
            self.usage.insert(key, at: 0)
        }
        return (graph, IN, OUT)
    }

    // TODO: add other graph factories (traceGraph, identityGraph, geoProdGraph) here…
}

