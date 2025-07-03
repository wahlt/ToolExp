#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Generates on-the-fly “virtual” geometry (e.g. fur, grass)
   via point‐sprite expansion in a compute pass.
2. Dependencies
   metal_stdlib
3. Overview
   - Reads base mesh points and normals.
   - Emits position + normal for each virtual strand point.
4. Usage
   - buffer[0]=basePoints, buffer[1]=baseNormals,
     buffer[2]=outVirtualPoints
5. Notes
   - Strand count per base point is a constant (e.g. 8).
*/

struct Base { float3 p; float3 n; };

kernel void virtualGeometryKernel(
    device const Base*   baseData    [[ buffer(0) ]],
    device float3*       outPoints   [[ buffer(1) ]],
    uint                 idx         [[ thread_position_in_grid ]]
) {
    // e.g. 8 virtual points per base
    const uint strands = 8;
    uint baseIdx = idx / strands;
    uint strandIdx = idx % strands;
    float3 p = baseData[baseIdx].p;
    float3 n = baseData[baseIdx].n;
    // jitter direction in tangent plane
    float angle = (strandIdx / float(strands)) * 2.0 * 3.1415926;
    float3 tangent = normalize(cross(n, float3(0,1,0)));
    float3 bitan  = cross(n, tangent);
    float3 dir = cos(angle)*tangent + sin(angle)*bitan;
    // offset length
    float length = 0.02;
    outPoints[idx] = p + dir * length;
}
