//
//  DeformKernel.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

/// Vertex deformation based on a simple noise field.
/// Assumes `inPositions` as float3 array and writes to `outPositions`.

kernel void deformKernel(
    device const float3* inPositions  [[buffer(0)]],
    device float3*       outPositions [[buffer(1)]],
    uint                  id          [[thread_position_in_grid]]
) {
    // 1. Read the input vertex
    float3 p = inPositions[id];

    // 2. Simple noise deformation (e.g. sin-wave)
    float noise = sin(p.x * 10.0) * cos(p.y * 10.0);
    float3 offset = float3(noise * 0.02, noise * 0.02, noise * 0.02);

    // 3. Write the deformed position
    outPositions[id] = p + offset;
}
