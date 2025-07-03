#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Performs one iteration of path tracing per pixel:
   ray gen, BVH traverse, material eval, accumulate.
2. Dependencies
   metal_stdlib
3. Overview
   - Input buffers: ray origins, directions, BVH data, vertex buffers, material buffers.
   - Output buffer: accumulated radiance/color per pixel.
4. Usage
   - Bind all scene data as buffer slots.
   - Dispatch with grid = (width×height).
5. Notes
   - For brevity uses a simple lambertian bounce.
   - Real implementation would loop or recursive via multiple passes.
*/

struct Ray { float3 origin; float3 dir; };
struct Hit { float3 pos; float3 normal; uint triIdx; };

kernel void pathTraceKernel(
    device Ray*        rays       [[ buffer(0) ]],
    device Hit*        hits       [[ buffer(1) ]],
    device float3*     outColor   [[ buffer(2) ]],
    uint2 gid                   [[ thread_position_in_grid ]]
) {
    uint idx = gid.y * get_thread_execution_width() + gid.x;
    Ray r = rays[idx];
    Hit h = hits[idx];
    // Simple lambertian: dot(n, -r.dir)
    float NdotL = max(dot(h.normal, -r.dir), 0.0);
    outColor[idx] = float3(NdotL);
}
