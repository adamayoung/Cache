//
//  CacheStoreable.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import Combine
import Foundation

public protocol CacheStoreable {

  func item<Item: Codable>(forKey key: String) -> Item?

  @discardableResult
  func setItem<Item: Codable>(_ item: Item, forKey key: String) -> Bool

  func removeItem(forKey key: String)

  func removeAll()

}

public extension CacheStoreable {

  func itemPublisher<Item: Codable>(forKey key: String) -> AnyPublisher<Item?, Never> {
    Future<Item?, Never> { promise in
      let item: Item? = self.item(forKey: key)
      promise(.success(item))
    }
    .eraseToAnyPublisher()
  }

  func setItemPublisher<Item: Codable>(_ item: Item, forKey key: String) -> AnyPublisher<Bool, Never> {
    Future<Bool, Never> { promise in
      let result = self.setItem(item, forKey: key)
      promise(.success(result))
    }
    .eraseToAnyPublisher()
  }

}

public extension CacheStoreable {

  func item<Item: Codable>(forKey key: UUID) -> Item? {
    item(forKey: key.uuidString)
  }

  func itemPublisher<Item: Codable>(forKey key: UUID) -> AnyPublisher<Item?, Never> {
    itemPublisher(forKey: key.uuidString)
  }

  @discardableResult
  func setItem<Item: Codable>(_ item: Item, forKey key: UUID) -> Bool {
    setItem(item, forKey: key.uuidString)
  }

  func setItemPublisher<Item: Codable>(_ item: Item, forKey key: UUID) -> AnyPublisher<Bool, Never> {
    setItemPublisher(item, forKey: key.uuidString)
  }

  func removeItem(forKey key: UUID) {
    removeItem(forKey: key.uuidString)
  }

}

public extension CacheStoreable {

  @discardableResult
  func setItem<Item: Codable & Identifiable>(_ item: Item) -> Bool where Item.ID == UUID {
    setItem(item, forKey: item.id)
  }

  func setItemPublisher<Item: Codable & Identifiable>(_ item: Item) -> AnyPublisher<Bool, Never>
    where Item.ID == UUID {
    setItemPublisher(item, forKey: item.id)
  }

}
