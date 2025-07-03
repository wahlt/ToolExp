//
//  StatsKit.swift
//  ToolMath
//
//  1. Purpose
//     Statistical tests and summaries.
// 2. Dependencies
//     Foundation, Accelerate
// 3. Overview
//     Mean, median, histogram, correlation.
// 4. Usage
//     `StatsKit.correlation(x,y)`
// 5. Notes
//     Operates on CPU arrays.

import Foundation
import Accelerate

public enum StatsKit {
    public static func mean(_ x: [Float]) -> Float {
        var m: Float = 0
        vDSP_meanv(x, 1, &m, vDSP_Length(x.count))
        return m
    }

    public static func median(_ x: [Float]) -> Float {
        var copy = x
        vDSP_vsort(copy, 1, vDSP_Length(copy.count))
        let m = copy.count/2
        return copy[m]
    }

    public static func histogram(
        _ x: [Float], bins: Int, range: ClosedRange<Float>
    ) -> [Int] {
        let width = (range.upperBound - range.lowerBound)/Float(bins)
        var counts = [Int](repeating: 0, count: bins)
        for v in x {
            let idx = min(bins-1, max(0, Int((v - range.lowerBound)/width)))
            counts[idx] += 1
        }
        return counts
    }

    public static func correlation(_ x: [Float], _ y: [Float]) -> Float {
        precondition(x.count == y.count)
        var meanX: Float = 0, meanY: Float = 0
        vDSP_meanv(x, 1, &meanX, vDSP_Length(x.count))
        vDSP_meanv(y, 1, &meanY, vDSP_Length(y.count))
        var num: Float = 0, denX: Float = 0, denY: Float = 0
        for i in 0..<x.count {
            let dx = x[i] - meanX, dy = y[i] - meanY
            num   += dx*dy
            denX  += dx*dx
            denY  += dy*dy
        }
        return num / sqrt(denX * denY)
    }
}
