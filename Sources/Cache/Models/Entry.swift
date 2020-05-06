//
//  Entry.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import Foundation

public struct Entry<Item: Codable> {

  public let item: Item
  public let filePath: String?

  init(item: Item, filePath: String? = nil) {
    self.item = item
    self.filePath = filePath
  }

}
