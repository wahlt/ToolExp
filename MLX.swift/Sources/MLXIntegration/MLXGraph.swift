//
//  MLXGraph.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// MLXCommandQueue.swift
import Metal

/// Manages creation of ML-specific encoders.
public final class MLXCommandQueue {
  let device: MTLDevice
  public init(device: MTLDevice) {
    self.device = device
  }

  public func makeCommandBuffer(queue: MTLCommandQueue) -> MTLCommandBuffer? {
    queue.makeCommandBuffer()
  }

  public func makeMLCommandEncoder(
    commandBuffer: MTLCommandBuffer
  ) -> MTLCommandEncoder? {
    // stub: in Metal 4 you'd call makeMachineLearningCommandEncoder()
    commandBuffer.makeComputeCommandEncoder()
  }
}
