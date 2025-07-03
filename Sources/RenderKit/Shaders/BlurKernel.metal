#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Performs a separable Gaussian blur on a 2D texture.
2. Dependencies
   metal_stdlib
3. Overview
   - Two kernels: horizontal pass then vertical pass.
   - Uses a 5-tap Gaussian [1,4,6,4,1]/16.
4. Usage
   dispatch `blurHorizontal` into a temp image,
   then dispatch `blurVertical` reading that temp and writing final.
5. Notes
   - Assumes `inTex` and `outTex` have identical dimensions and pixel formats.
   - Border clamped.
*/

constexpr sampler s(address::clamp_to_edge, filter::nearest);

kernel void blurHorizontal(
    texture2d<float, access::read>  inTex  [[ texture(0) ]],
    texture2d<float, access::write> outTex [[ texture(1) ]],
    uint2 gid                              [[ thread_position_in_grid ]]
) {
    if (gid.x >= inTex.get_width() || gid.y >= inTex.get_height()) return;
    float4 sum = float4(0.0);
    constexpr float kernel[5] = {1/16.0, 4/16.0, 6/16.0, 4/16.0, 1/16.0};
    int2 coords = int2(gid);
    // horizontal 5-tap
    for (int i = -2; i <= 2; i++) {
        sum += inTex.sample(s, float2(coords.x + i, coords.y)) * kernel[i+2];
    }
    outTex.write(sum, gid);
}

kernel void blurVertical(
    texture2d<float, access::read>  inTex  [[ texture(0) ]],
    texture2d<float, access::write> outTex [[ texture(1) ]],
    uint2 gid                              [[ thread_position_in_grid ]]
) {
    if (gid.x >= inTex.get_width() || gid.y >= inTex.get_height()) return;
    float4 sum = float4(0.0);
    constexpr float kernel[5] = {1/16.0, 4/16.0, 6/16.0, 4/16.0, 1/16.0};
    int2 coords = int2(gid);
    // vertical 5-tap
    for (int j = -2; j <= 2; j++) {
        sum += inTex.sample(s, float2(coords.x, coords.y + j)) * kernel[j+2];
    }
    outTex.write(sum, gid);
}
