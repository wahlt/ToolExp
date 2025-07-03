#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Extracts bright regions (threshold) and blurs them for bloom.
2. Dependencies
   metal_stdlib
3. Overview
   - Kernel 1: threshold to isolate highlights.
   - Kernel 2: separable 7-tap blur on highlights.
4. Usage
   - Dispatch `extractBright`, then `bloomHorizontal`, then `bloomVertical`.
5. Notes
   - Weight and threshold are constants for now.
*/

constexpr sampler s(address::clamp_to_edge, filter::nearest);
constexpr float THRESH = 1.0; // only pixels brighter than this
constexpr float KERNEL7[7] = {1/64, 6/64,15/64,20/64,15/64,6/64,1/64};

kernel void extractBright(
    texture2d<float, access::read>  inTex   [[ texture(0) ]],
    texture2d<float, access::write> bright  [[ texture(1) ]],
    uint2 gid                                [[ thread_position_in_grid ]]
) {
    if (gid.x >= inTex.get_width() || gid.y >= inTex.get_height()) return;
    float4 c = inTex.sample(s, float2(gid));
    float lum = dot(c.rgb, float3(0.299,0.587,0.114));
    bright.write(lum > THRESH ? c : float4(0), gid);
}

kernel void bloomHorizontal(
    texture2d<float, access::read>  inTex  [[ texture(0) ]],
    texture2d<float, access::write> outTex [[ texture(1) ]],
    uint2 gid                             [[ thread_position_in_grid ]]
) {
    if (gid.x >= inTex.get_width() || gid.y >= inTex.get_height()) return;
    float4 sum = float4(0.0);
    int2 c = int2(gid);
    for (int i=-3; i<=3; i++) {
        sum += inTex.sample(s, float2(c.x+i,c.y)) * KERNEL7[i+3];
    }
    outTex.write(sum, gid);
}

kernel void bloomVertical(
    texture2d<float, access::read>  inTex  [[ texture(0) ]],
    texture2d<float, access::write> outTex [[ texture(1) ]],
    uint2 gid                             [[ thread_position_in_grid ]]
) {
    if (gid.x >= inTex.get_width() || gid.y >= inTex.get_height()) return;
    float4 sum = float4(0.0);
    int2 c = int2(gid);
    for (int j=-3; j<=3; j++) {
        sum += inTex.sample(s, float2(c.x,c.y+j)) * KERNEL7[j+3];
    }
    outTex.write(sum, gid);
}
