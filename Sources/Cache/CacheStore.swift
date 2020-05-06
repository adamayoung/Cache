//
//  CacheStore.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import Foundation

public final class CacheStore {

  private let memoryCacheStore: CacheStoreable
  private let diskCacheStore: CacheStoreable

  public init(memoryCacheStore: CacheStoreable, diskCacheStore: CacheStoreable) {
    self.memoryCacheStore = memoryCacheStore
    self.diskCacheStore = diskCacheStore
  }

  public convenience init(name: String) {
    let memoryCacheStore = MemoryCacheStore(name: name)
    let diskCacheStore = DiskCacheStore(name: name)
    self.init(memoryCacheStore: memoryCacheStore, diskCacheStore: diskCacheStore)
  }

}

extension CacheStore: CacheStoreable {

  public func item<Item: Codable>(forKey key: String) -> Item? {
    if let memoryItem: Item = memoryCacheStore.item(forKey: key) {
      return memoryItem
    }

    guard let item: Item = diskCacheStore.item(forKey: key) else {
      return nil
    }

    memoryCacheStore.setItem(item, forKey: key)
    return item
  }

  @discardableResult
  public func setItem<Item: Codable>(_ item: Item, forKey key: String) -> Bool {
    let memoryCacheResult = memoryCacheStore.setItem(item, forKey: key)
    let diskCacheResult = diskCacheStore.setItem(item, forKey: key)
    return memoryCacheResult && diskCacheResult
  }

  public func removeItem(forKey key: String) {
    memoryCacheStore.removeItem(forKey: key)
    diskCacheStore.removeItem(forKey: key)
  }

  public func removeAll() {
    memoryCacheStore.removeAll()
    diskCacheStore.removeAll()
  }

}
