//
//  OptionBloom.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

/// “Option bloom” effect: bright-pass + gaussian blur.
///   1) Extract pixels above threshold.
///   2) Apply small blur pass.
///   3) Write to bloom texture.

struct BloomParams {
    float threshold;
    float intensity;
};

kernel void optionBloomKernel(
    texture2d<float, access::read>  inTexture   [[texture(0)]],
    texture2d<float, access::write> bloomTexture [[texture(1)]],
    constant BloomParams&           params       [[buffer(0)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= inTexture.get_width() || gid.y >= inTexture.get_height()) {
        return;
    }

    float4 color = inTexture.read(gid);
    float lum = dot(color.rgb, float3(0.299, 0.587, 0.114));

    if (lum > params.threshold) {
        // simple 3×3 blur around bright pixels
        float4 sum = float4(0.0);
        int radius = 1;
        for (int dx = -radius; dx <= radius; dx++) {
            for (int dy = -radius; dy <= radius; dy++) {
                sum += inTexture.read(uint2(gid + uint2(dx, dy)));
            }
        }
        bloomTexture.write(sum / 9.0 * params.intensity, gid);
    } else {
        bloomTexture.write(float4(0.0), gid);
    }
}
