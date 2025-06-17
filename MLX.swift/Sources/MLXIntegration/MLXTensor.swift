//
//  MLXTensor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/17/25.
//

// MLXTensor.swift
import Metal

/// Represents a tensor backed by a GPU buffer or texture.
public struct MLXTensor {
  public let device: MTLDevice
  public let buffer: MTLBuffer

  public init(device: MTLDevice, length: Int) {
    self.device = device
    self.buffer = device.makeBuffer(length: length, options: [])!
  }
}
