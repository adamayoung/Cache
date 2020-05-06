//
//  MemoryCacheStore.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import Foundation

public final class MemoryCacheStore {

  private let cache = NSCache<NSString, MemoryCapsule>()
  private let config: MemoryConfig

  public init(config: MemoryConfig) {
    self.config = config
    self.cache.countLimit = Int(config.countLimit)
    self.cache.totalCostLimit = Int(config.totalCostLimit)
  }

  public convenience init(name: String) {
    let config = MemoryConfig(name: name)
    self.init(config: config)
  }

}

extension MemoryCacheStore: CacheStoreable {

  public func item<Item: Codable>(forKey key: String) -> Item? {
    guard let capsule = cache.object(forKey: NSString(string: key)) else {
      return nil
    }

    guard let item = capsule.item as? Item else {
      return nil
    }

    return item
  }

  @discardableResult
  public func setItem<Item: Codable>(_ item: Item, forKey key: String) -> Bool {
    let capsule = MemoryCapsule(item: item)
    cache.setObject(capsule, forKey: NSString(string: key))
    return true
  }

  public func removeItem(forKey key: String) {
    cache.removeObject(forKey: NSString(string: key))
  }

  public func removeAll() {
    cache.removeAllObjects()
  }

}
