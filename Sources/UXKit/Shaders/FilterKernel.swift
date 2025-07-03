//
//  FilterKernel.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

#include <metal_stdlib>
using namespace metal;

// Gaussian blur kernel example.
// buffer(0): input texture
// texture(1): output texture
// constant(0): float sigma

kernel void gaussianBlur(
    texture2d<float, access::read>  inTex  [[ texture(0) ]],
    texture2d<float, access::write> outTex [[ texture(1) ]],
    constant float& sigma                   [[ buffer(0) ]],
    uint2 gid                               [[ thread_position_in_grid ]]
) {
    uint w = inTex.get_width(), h = inTex.get_height();
    if (gid.x >= w || gid.y >= h) return;

    constexpr int K = 5;
    float sum = 0.0, norm = 0.0;
    float inv2 = 1.0 / (2.0 * sigma * sigma);

    for (int oy=-K; oy<=K; ++oy) {
        for (int ox=-K; ox<=K; ++ox) {
            int2 coord = int2(gid) + int2(ox, oy);
            if (coord.x<0 || coord.x>=w || coord.y<0 || coord.y>=h) continue;
            float weight = exp(-float(ox*ox+oy*oy)*inv2);
            sum  += inTex.read(uint2(coord)).r * weight;
            norm += weight;
        }
    }
    float val = sum / norm;
    outTex.write(float4(val, val, val, 1.0), gid);
}
