#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Applies per-vertex displacement to a mesh via a compute shader.
2. Dependencies
   metal_stdlib
3. Overview
   - Reads input vertex positions and per-vertex offsets.
   - Writes deformed positions out.
4. Usage
   - Buffer[0]: array<float3> basePositions
   - Buffer[1]: array<float3> offsets
   - Buffer[2]: array<float3> outputPositions
   - Threadgroup size tuned to vertex count.
5. Notes
   - No fallback: expects one-to-one mapping.
*/

kernel void deformKernel(
    device const float3* basePos    [[ buffer(0) ]],
    device const float3* offsets    [[ buffer(1) ]],
    device float3*       outPos     [[ buffer(2) ]],
    uint                 idx        [[ thread_position_in_grid ]]
) {
    // Simply add offset to base position
    outPos[idx] = basePos[idx] + offsets[idx];
}
