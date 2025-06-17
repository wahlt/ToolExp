//
//  ShaderML.metal
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

#include <metal_stdlib>
#include <metal_ml>
using namespace metal;
using namespace ml;

/// Tiny embedded ML filter using Metal 4’s ml:: API.
/// Expects a pre-compiled ML model in the default library.

kernel void shaderML(
    device const float* inputData  [[buffer(0)]],
    device float*       outputData [[buffer(1)]],
    uint id [[thread_position_in_grid]]
) {
    // 1. Wrap the raw pointer in an ML Tensor
    auto inTensor  = graph::tensor({1, 64, 64, 3}, inputData);
    auto outTensor = graph::tensor({1, 64, 64, 3});

    // 2. Load the tiny filter network by symbol name
    auto model = graph::loadModel("tiny_filter");

    // 3. Enqueue the predict pass
    model.predict(inTensor, outTensor);

    // 4. Write back the result
    outTensor.read(outputData + id, 1);
}
