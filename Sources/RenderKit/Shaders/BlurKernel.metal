//
//  BlurKernel.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

/// Simple box-blur kernel for HDR textures.
/// Reads a 9×9 neighborhood around each pixel, averages, writes output.

kernel void blurKernel(
    texture2d<float, access::read>  inTexture  [[texture(0)]],
    texture2d<float, access::write> outTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    // 1. Bounds check
    if (gid.x >= outTexture.get_width() || gid.y >= outTexture.get_height()) {
        return;
    }

    // 2. Accumulate neighbors
    constexpr int radius = 4;
    float4 sum = float4(0.0);
    int count = 0;
    int2 size = int2(inTexture.get_width(), inTexture.get_height());

    for (int dx = -radius; dx <= radius; dx++) {
        for (int dy = -radius; dy <= radius; dy++) {
            int2 coord = int2(gid) + int2(dx, dy);
            if (coord.x >= 0 && coord.x < size.x && coord.y >= 0 && coord.y < size.y) {
                sum += inTexture.read(uint2(coord));
                count++;
            }
        }
    }

    // 3. Write the average
    outTexture.write(sum / float(count), gid);
}
