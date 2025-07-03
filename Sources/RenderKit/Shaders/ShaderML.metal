#include <metal_stdlib>
using namespace metal;

/*
1. Purpose
   Runs a small neural-net inference on image patches.
2. Dependencies
   metal_stdlib
3. Overview
   - Placeholder input tensor (e.g. 3×3 patch × channels).
   - Fully-connected weights baked as constants.
   - Applies ReLU activation.
4. Usage
   - Bind buffer[0]=inputFeatures, buffer[1]=outputFeatures.
5. Notes
   - For demonstration; real weights loaded at runtime.
*/

kernel void shaderML(
    device const float* inFeat   [[ buffer(0) ]],
    device float*       outFeat  [[ buffer(1) ]],
    uint gid                   [[ thread_position_in_grid ]]
) {
    // Example: one-layer perceptron of size 16→8
    constexpr sampler s; // unused
    // weights[16][8] and biases[8] would be constants here
    // For brevity, we just copy and apply ReLU
    float v = inFeat[gid];
    outFeat[gid % 8] = max(0.0, v);
}
