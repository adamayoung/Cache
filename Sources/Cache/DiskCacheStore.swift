//
//  DiskCacheStore.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import CryptoKit
import Foundation

public final class DiskCacheStore {

  enum Error: Swift.Error {
    case fileEnumeratorFailed
  }

  private let fileManager: FileManager
  private let config: DiskConfig
  private let path: String
  let encoder: JSONEncoder = .init()
  let decoder: JSONDecoder = .init()

  public init(config: DiskConfig, fileManager: FileManager = .default) {
    self.config = config
    self.fileManager = fileManager

    let url: URL?
    if let directory = config.directory {
      url = directory
    } else {
      url = try? fileManager.url(
        for: .cachesDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
    }

    self.path = url?.appendingPathComponent(config.name, isDirectory: true).path ?? ""

    try? createDirectory()

    #if os(iOS) || os(tvOS)
    if let protectionType = config.protectionType {
      try? setDirectoryAttributes([
        FileAttributeKey.protectionKey: protectionType
      ])
    }
    #endif
  }

  public convenience init(name: String) {
    let config = DiskConfig(name: name)
    self.init(config: config)
  }

}

extension DiskCacheStore: CacheStoreable {

  public func item<Item: Codable>(forKey key: String) -> Item? {
    let entry: Entry<Item>? = self.entry(forKey: key)
    return entry?.item
  }

  @discardableResult
  public func setItem<Item: Codable>(_ item: Item, forKey key: String) -> Bool {
    let data: Data
    do {
      data = try encoder.encode(item)
    } catch {
      return false
    }

    let filePath = makeFilePath(for: key)
    let result = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    return result
  }

  public func removeItem(forKey key: String) {
    let filePath = makeFilePath(for: key)
    try? fileManager.removeItem(atPath: filePath)
  }

  public func removeAll() {
    try? fileManager.removeItem(atPath: path)
    try? createDirectory()
  }

}

extension DiskCacheStore {

  private func entry<Item: Codable>(forKey key: String) -> Entry<Item>? {
    let filePath = makeFilePath(for: key)
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
      return nil
    }

    do {
      let item = try decoder.decode(Item.self, from: data)
      return Entry(item: item, filePath: filePath)
    } catch {
      removeItem(forKey: key)
      return nil
    }
  }

  private func setDirectoryAttributes(_ attributes: [FileAttributeKey: Any]) throws {
    try fileManager.setAttributes(attributes, ofItemAtPath: path)
  }

}

extension DiskCacheStore {

  private func makeFilePath(for key: String) -> String {
    "\(path)/\(key))"
  }

  private func createDirectory() throws {
    guard !fileManager.fileExists(atPath: path) else {
      return
    }

    try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true,
                                    attributes: nil)
  }

}
