//
//  SmudgeKernel.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
using namespace metal;

/// Smudge effect: drags pixels along a vector direction
/// based on a “smudge map” stored in the alpha channel.

kernel void smudgeKernel(
    texture2d<float, access::read>  inTexture     [[texture(0)]],
    texture2d<float, access::write> outTexture    [[texture(1)]],
    texture2d<float, access::read>  smudgeMap     [[texture(2)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= inTexture.get_width() || gid.y >= inTexture.get_height()) return;

    float4 src = inTexture.read(gid);
    float2 offset = smudgeMap.read(gid).xy * 10.0;  // scale factor

    int2 coord = int2(gid) + int2(offset);
    coord = clamp(coord, int2(0), int2(inTexture.get_width()-1, inTexture.get_height()-1));

    float4 smeared = inTexture.read(uint2(coord));
    outTexture.write(smeared, gid);
}
