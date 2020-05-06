//
//  MemoryConfig.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import Foundation

public struct MemoryConfig {

  public let name: String
  public let countLimit: UInt
  public let totalCostLimit: UInt

  public init(name: String, countLimit: UInt = 0, totalCostLimit: UInt = 0) {
    self.name = name
    self.countLimit = countLimit
    self.totalCostLimit = totalCostLimit
  }

}
