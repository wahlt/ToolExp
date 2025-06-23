//
//  ShaderML.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

// A tiny in-shader CNN layer for color grading.
//
// This replaces the unavailable `<metal_ml>` header.
// It performs a simple 3×3 blur-style convolution inline.

fragment half4 ml_colorEnhancer(
    texture2d<half, access::read> inTexture [[texture(0)]],
    sampler             s         [[sampler(0)]],
    uint2               gid       [[thread_position_in_grid]]
) {
    half4 orig = inTexture.read(gid);

    // 3×3 convolution kernel
    constexpr half kernel[3][3] = {
        { 0.0, 0.1, 0.0 },
        { 0.1, 0.6, 0.1 },
        { 0.0, 0.1, 0.0 }
    };

    half3 sum = half3(0.0);
    for (uint yy = 0; yy < 3; yy++) {
        for (uint xx = 0; xx < 3; xx++) {
            uint2 coord = gid + uint2(xx - 1, yy - 1);
            half4 sample = inTexture.read(coord);
            sum += sample.rgb * kernel[yy][xx];
        }
    }

    // Mix original and filtered color 50/50
    half3 blended = mix(orig.rgb, sum, half(0.5));
    return half4(blended, orig.a);
}
