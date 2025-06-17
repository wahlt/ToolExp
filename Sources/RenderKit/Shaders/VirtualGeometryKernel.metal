//
//  VirtualGeometryKernel.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

/// Virtual geometry compute kernel stub.
/// Reads input vertex positions and outputs a tessellated mesh.
/// To be used via the `VirtualGeometry` Swift class.

struct GeoParams {
    uint vertexCount;
    uint indexCount;
};

kernel void virtual_geometry_kernel(
    device const float3* inVertices     [[buffer(0)]],
    device const uint3*  inIndices      [[buffer(1)]],
    device float3*       outVertices    [[buffer(2)]],
    device uint3*        outIndices     [[buffer(3)]],
    constant GeoParams&  params         [[buffer(4)]],
    uint id [[thread_position_in_grid]]
) {
    if (id >= params.vertexCount) return;

    // 1. Copy original vertex
    float3 pos = inVertices[id];
    outVertices[id] = pos;

    // 2. Simple subdivision: for each input triangle, output as-is.
    //    Real implementation would compute new vertices/indices here.
    //    This stub just copies indices directly.
    if (id < params.indexCount) {
        outIndices[id] = inIndices[id];
    }
}
