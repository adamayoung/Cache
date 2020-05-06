//
//  MemoryCacheStoreTests.swift
//  CacheTests
//
//  Created by Adam Young on 01/10/2019.
//

@testable import Cache
import XCTest

final class MemoryCacheStoreTests: XCTestCase {

  var cacheStore: MemoryCacheStore!

  override func setUp() {
    super.setUp()
    cacheStore = MemoryCacheStore(name: "memoryCacheStoreTests")
  }

  override func tearDown() {
    cacheStore.removeAll()
    cacheStore = nil
    super.tearDown()
  }

}

extension MemoryCacheStoreTests {

  func testItemForKey_whenDoesNotContainItemWithKey_shouldReturnNil() {
    let key = UUID().uuidString
    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

  func testItemForKey_whenContainsItemWithKey_shouldReturnItem() {
    let key = UUID().uuidString
    let expectedResult = MockCacheItem(name: "some_name")
    cacheStore.setItem(expectedResult, forKey: key)

    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertEqual(result, expectedResult)
  }

  func testItemForKey_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil() {
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: UUID().uuidString)

    let result: MockCacheItem? = cacheStore.item(forKey: UUID().uuidString)

    XCTAssertNil(result)
  }

  func testItemForKey_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem() {
    let key = UUID().uuidString
    let expectedResult = MockCacheItem(name: "some_name")
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: UUID().uuidString)
    cacheStore.setItem(expectedResult, forKey: key)
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: UUID().uuidString)

    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertEqual(result, expectedResult)
  }

  func testItemForKey_whenContainsItemWithKeyAndDifferentType_shouldReturnNil() {
    let key = UUID().uuidString
    let item = MockCacheItem(name: "some_name")
    cacheStore.setItem(item, forKey: key)

    let result: MockCacheItem2? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

}

extension MemoryCacheStoreTests {

  func testRemoveItem_shouldRemoveItem() {
    let key = UUID().uuidString
    let item = MockCacheItem(name: "some_name")
    cacheStore.setItem(item, forKey: key)

    let cachedItem: MockCacheItem? = cacheStore.item(forKey: key)
    XCTAssertNotNil(cachedItem)

    cacheStore.removeItem(forKey: key)
    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

  func testRemoveItem_whenContainsMultipleItems_shouldReturnItem() {
    let key = UUID().uuidString
    let item = MockCacheItem(name: "some_name")
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: UUID().uuidString)
    cacheStore.setItem(item, forKey: key)
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: UUID().uuidString)
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: UUID().uuidString)

    let cachedItem: MockCacheItem? = cacheStore.item(forKey: key)
    XCTAssertNotNil(cachedItem)

    cacheStore.removeItem(forKey: key)
    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

  func testRemoveAll_shouldRemoveAllItems() {
    let key1 = UUID().uuidString
    let key2 = UUID().uuidString
    let key3 = UUID().uuidString
    let key4 = UUID().uuidString
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: key1)
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: key2)
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: key3)
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: key4)

    let cachedItem1: MockCacheItem? = cacheStore.item(forKey: key1)
    XCTAssertNotNil(cachedItem1)
    let cachedItem2: MockCacheItem? = cacheStore.item(forKey: key2)
    XCTAssertNotNil(cachedItem2)
    let cachedItem3: MockCacheItem? = cacheStore.item(forKey: key3)
    XCTAssertNotNil(cachedItem3)
    let cachedItem4: MockCacheItem? = cacheStore.item(forKey: key4)
    XCTAssertNotNil(cachedItem4)

    cacheStore.removeAll()

    let result1: MockCacheItem? = cacheStore.item(forKey: key1)
    XCTAssertNil(result1)
    let result2: MockCacheItem? = cacheStore.item(forKey: key2)
    XCTAssertNil(result2)
    let result3: MockCacheItem? = cacheStore.item(forKey: key3)
    XCTAssertNil(result3)
    let result4: MockCacheItem? = cacheStore.item(forKey: key4)
    XCTAssertNil(result4)
  }

}

extension MemoryCacheStoreTests {

  static var allTests = [
    ("testItemForKey_whenDoesNotContainItemWithKey_shouldReturnNil",
     testItemForKey_whenDoesNotContainItemWithKey_shouldReturnNil),
    ("testItemForKey_whenContainsItemWithKey_shouldReturnItem",
     testItemForKey_whenContainsItemWithKey_shouldReturnItem),
    ("testItemForKey_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil",
     testItemForKey_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil),
    ("testItemForKey_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem",
     testItemForKey_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem),
    ("testItemForKey_whenContainsItemWithKeyAndDifferentType_shouldReturnNil",
     testItemForKey_whenContainsItemWithKeyAndDifferentType_shouldReturnNil),
    ("testRemoveItem_shouldRemoveItem", testRemoveItem_shouldRemoveItem),
    ("testRemoveItem_whenContainsMultipleItems_shouldReturnItem",
     testRemoveItem_whenContainsMultipleItems_shouldReturnItem),
    ("testRemoveAll_shouldRemoveAllItems", testRemoveAll_shouldRemoveAllItems)
  ]

}

private struct MockCacheItem: Codable, Equatable {

  let name: String

}

private struct MockCacheItem2: Codable, Equatable {

  let text: String

}
