//
//  DiskConfig.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import Foundation

public struct DiskConfig {

  public let name: String
  public let maxSize: UInt
  public let directory: URL?

  #if os(iOS) || os(tvOS)
  public let protectionType: FileProtectionType?

  public init(name: String, maxSize: UInt = 0, directory: URL? = nil,
              protectionType: FileProtectionType? = .completeUntilFirstUserAuthentication) {
    self.name = name
    self.maxSize = maxSize
    self.directory = directory
    self.protectionType = protectionType
  }
  #else
  public init(name: String, maxSize: UInt = 0, directory: URL? = nil) {
    self.name = name
    self.maxSize = maxSize
    self.directory = directory
  }
  #endif

}
