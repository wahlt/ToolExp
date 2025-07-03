#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Smudges an image by dragging pixels along a vector field.
2. Dependencies
   metal_stdlib
3. Overview
   - Reads source texture and a float2 vector field.
   - For each pixel, samples upstream along the vector and blends.
4. Usage
   - texture(0)=source image, texture(1)=vectorField,
     texture(2)=output image.
5. Notes
   - `strength` controls smudge length.
*/

constexpr sampler s(address::clamp_to_edge, filter::linear);
constant float strength = 5.0;

kernel void smudgeKernel(
    texture2d<float, access::read>  srcTex   [[ texture(0) ]],
    texture2d<float, access::read>  vecField [[ texture(1) ]],
    texture2d<float, access::write> outTex   [[ texture(2) ]],
    uint2 gid                                     [[ thread_position_in_grid ]]
) {
    if (gid.x >= srcTex.get_width() || gid.y >= srcTex.get_height()) return;
    float2 uv = float2(gid) / float2(srcTex.get_width(), srcTex.get_height());
    float2 dir = vecField.sample(s, uv).xy * strength;
    // Sample halfway upstream
    float2 sampleUV = uv - dir * 0.5;
    float4 orig = srcTex.sample(s, uv);
    float4 smeared = srcTex.sample(s, sampleUV);
    outTex.write(mix(orig, smeared, 0.5), gid);
}
