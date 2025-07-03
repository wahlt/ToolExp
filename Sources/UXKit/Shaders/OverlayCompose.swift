//
//  OverlayCompose.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

#include <metal_stdlib>
using namespace metal;

// buffer(0): float2 pts[]
// buffer(1): uint   pointCount
// texture(0): read/write overlay

kernel void composeOverlay(
    const device float2* pts    [[ buffer(0) ]],
    const device uint*    cnt   [[ buffer(1) ]],
    texture2d<float, access::read_write> outTex [[ texture(0) ]],
    uint2 gid                               [[ thread_position_in_grid ]]
) {
    uint width  = outTex.get_width();
    uint height = outTex.get_height();
    if (gid.x >= width || gid.y >= height) return;

    float2 uv = float2(gid) / float2(width, height);
    float accum = 0.0;
    for (uint i = 0; i < *cnt; i++) {
        float2 p = pts[i];
        float d = distance(uv, p);
        accum += exp(-d*d * 200.0);
    }
    float4 prev = outTex.read(gid);
    // fade existing by 90% each pass
    float4 faded = prev * 0.9;
    float4 col   = float4(accum, accum, accum, 1.0);
    outTex.write(faded + col, gid);
}
