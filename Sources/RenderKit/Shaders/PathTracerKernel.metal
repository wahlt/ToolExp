//
//  PathTracerKernel.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

/// Minimal path tracer: casts one random ray per pixel,
/// accumulates a simple direct lighting.

struct FrameUniforms {
    float3  camPos;
    float3  camDir;
    uint    frameIndex;
};

kernel void pathTracerKernel(
    texture2d<float, access::read>  accumTexture   [[texture(0)]],
    texture2d<float, access::write> outTexture     [[texture(1)]],
    constant FrameUniforms&         uniforms       [[buffer(0)]],
    uint2 gid [[thread_position_in_grid]]
) {
    // 1. Jitter UV per frame for TAA
    float2 uv = (float2(gid) + rand(float2(gid))) / float2(outTexture.get_width(), outTexture.get_height());

    // 2. Generate primary ray (simple pinhole)
    float3 rayDir = normalize(uniforms.camDir + float3(uv - 0.5, 0.0));

    // 3. Scene intersection stub → always returns ground plane at y=0
    float t = (0.0 - uniforms.camPos.y) / rayDir.y;
    float3 pos = uniforms.camPos + rayDir * t;

    // 4. Compute simple shading: diffuse with sky color
    float3 skyColor = float3(0.6, 0.7, 0.9);
    float3 groundColor = float3(0.8, 0.7, 0.6);
    float lambert = max(dot(float3(0,1,0), float3(0,1,0)), 0.0);

    float3 radiance = mix(skyColor, groundColor * lambert, step(0.0, pos.y));

    // 5. Accumulate with previous frame for simple TAA
    float3 prev = accumTexture.read(gid).rgb;
    float3 color = mix(prev, radiance, 1.0 / float(uniforms.frameIndex + 1));

    outTexture.write(float4(color, 1.0), gid);
}
