//
//  CacheStoreableTests.swift
//  Cache
//
//  Created by Adam Young on 02/10/2019.
//

@testable import Cache
import Combine
import XCTest

// swiftlint:disable file_length
final class CacheStoreableTests: XCTestCase {

  var cacheStore: MockCacheStore!

  override func setUp() {
    super.setUp()
    cacheStore = MockCacheStore()
  }

  override func tearDown() {
    cacheStore.removeAll()
    cacheStore = nil
    super.tearDown()
  }

}

extension CacheStoreableTests {

  func testItemForKeyPublisher_whenDoesNotContainItemWithKey_shouldReturnNil() {
    let key = UUID().uuidString

    let promise = expectation(description: "itemForKeyPublisher")
    let cancellable = cacheStore.itemPublisher(forKey: key)
      .sink(receiveCompletion: { _ in
        promise.fulfill()
      }, receiveValue: { (result: MockCacheItem?) in
        XCTAssertNil(result)
      })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForKeyPublisher_whenContainsItemWithKey_shouldReturnItem() {
    let key = UUID().uuidString
    let expectedResult = MockCacheItem(name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")

    let cancellable = cacheStore.setItemPublisher(expectedResult, forKey: key)
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: key)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem?) in
      XCTAssertEqual(result, expectedResult)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForKeyPublisher_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil() {
    let promise = expectation(description: "itemForKeyPublisher")

    let sequence = [
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_1"), forKey: UUID().uuidString),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_2"), forKey: UUID().uuidString),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_3"), forKey: UUID().uuidString),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_4"), forKey: UUID().uuidString)
    ]

    let cancellable = Publishers.Sequence(sequence: sequence)
      .flatMap { $0 }
      .collect()
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: UUID().uuidString)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem?) in
      XCTAssertNil(result)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForKeyPublisher_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem() {
    let key = UUID().uuidString
    let expectedResult = MockCacheItem(name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")

    let sequence = [
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_1"), forKey: UUID().uuidString),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_2"), forKey: UUID().uuidString),
      cacheStore.setItemPublisher(expectedResult, forKey: key),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_3"), forKey: UUID().uuidString),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_4"), forKey: UUID().uuidString)
    ]

    let cancellable = Publishers.Sequence(sequence: sequence)
      .flatMap { $0 }
      .collect()
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: key)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem?) in
      XCTAssertEqual(result, expectedResult)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForKeyPublisher_whenContainsItemWithKeyAndDifferentType_shouldReturnNil() {
    let key = UUID().uuidString
    let item = MockCacheItem(name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")
    let cancellable = cacheStore.setItemPublisher(item, forKey: key)
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: key)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem2?) in
      XCTAssertNil(result)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

}

extension CacheStoreableTests {

  func testItemForUUIDKeyPublisher_whenDoesNotContainItemWithKey_shouldReturnNil() {
    let key = UUID()

    let promise = expectation(description: "itemForKeyPublisher")
    let cancellable = cacheStore.itemPublisher(forKey: key)
      .sink(receiveCompletion: { _ in
        promise.fulfill()
      }, receiveValue: { (result: MockCacheItem?) in
        XCTAssertNil(result)
      })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForUUIDKeyPublisher_whenContainsItemWithKey_shouldReturnItem() {
    let key = UUID()
    let expectedResult = MockCacheItem(name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")

    let cancellable = cacheStore.setItemPublisher(expectedResult, forKey: key)
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: key)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem?) in
      XCTAssertEqual(result, expectedResult)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForUUIDKeyPublisher_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil() {
    let promise = expectation(description: "itemForKeyPublisher")

    let sequence = [
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_1"), forKey: UUID()),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_2"), forKey: UUID()),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_3"), forKey: UUID()),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_4"), forKey: UUID())
    ]

    let cancellable = Publishers.Sequence(sequence: sequence)
      .flatMap { $0 }
      .collect()
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: UUID())
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem?) in
      XCTAssertNil(result)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForUUIDKeyPublisher_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem() {
    let key = UUID()
    let expectedResult = MockCacheItem(name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")

    let sequence = [
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_1"), forKey: UUID()),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_2"), forKey: UUID()),
      cacheStore.setItemPublisher(expectedResult, forKey: key),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_3"), forKey: UUID()),
      cacheStore.setItemPublisher(MockCacheItem(name: "some_name_4"), forKey: UUID())
    ]

    let cancellable = Publishers.Sequence(sequence: sequence)
      .flatMap { $0 }
      .collect()
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: key)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem?) in
      XCTAssertEqual(result, expectedResult)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testItemForUUIDKeyPublisher_whenContainsItemWithKeyAndDifferentType_shouldReturnNil() {
    let key = UUID()
    let item = MockCacheItem(name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")
    let cancellable = cacheStore.setItemPublisher(item, forKey: key)
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: key)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem2?) in
      XCTAssertNil(result)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

}

extension CacheStoreableTests {

  func testItemForUUIDKey_whenDoesNotContainItemWithKey_shouldReturnNil() {
    let key = UUID()
    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

  func testItemForUUIDKey_whenContainsItemWithKey_shouldReturnItem() {
    let key = UUID()
    let expectedResult = MockCacheItem(name: "some_name")
    cacheStore.setItem(expectedResult, forKey: key)

    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertEqual(result, expectedResult)
  }

  func testItemForUUIDKey_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil() {
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: UUID())

    let result: MockCacheItem? = cacheStore.item(forKey: UUID().uuidString)

    XCTAssertNil(result)
  }

  func testItemForUUIDKey_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem() {
    let key = UUID()
    let expectedResult = MockCacheItem(name: "some_name")
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: UUID())
    cacheStore.setItem(expectedResult, forKey: key)
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: UUID())

    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertEqual(result, expectedResult)
  }

  func testItemForUUIDKey_whenContainsItemWithKeyAndDifferentType_shouldReturnNil() {
    let key = UUID()
    let item = MockCacheItem(name: "some_name")
    cacheStore.setItem(item, forKey: key)

    let result: MockCacheItem2? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

}

extension CacheStoreableTests {

  func testRemoveItemForUUIDKey_shouldRemoveItem() {
    let key = UUID()
    let item = MockCacheItem(name: "some_name")
    cacheStore.setItem(item, forKey: key)

    let cachedItem: MockCacheItem? = cacheStore.item(forKey: key)
    XCTAssertNotNil(cachedItem)

    cacheStore.removeItem(forKey: key)
    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

  func testRemoveItemForUUIDKey_whenContainsMultipleItems_shouldReturnItem() {
    let key = UUID()
    let item = MockCacheItem(name: "some_name")
    cacheStore.setItem(MockCacheItem(name: "some_name_1"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_2"), forKey: UUID())
    cacheStore.setItem(item, forKey: key)
    cacheStore.setItem(MockCacheItem(name: "some_name_3"), forKey: UUID())
    cacheStore.setItem(MockCacheItem(name: "some_name_4"), forKey: UUID())

    let cachedItem: MockCacheItem? = cacheStore.item(forKey: key)
    XCTAssertNotNil(cachedItem)

    cacheStore.removeItem(forKey: key)
    let result: MockCacheItem? = cacheStore.item(forKey: key)

    XCTAssertNil(result)
  }

  func testRemoveAllForUUIDKey_shouldRemoveAllItems() {
    let key1 = UUID()
    let key2 = UUID()
    let key3 = UUID()
    let key4 = UUID()
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

extension CacheStoreableTests {

  func testSetItemWithIdentifiable_shouldSetItem() {
    let id = UUID()
    let expectedResult = MockCacheItem3(id: id, name: "some_name")
    cacheStore.setItem(expectedResult)

    let result: MockCacheItem3? = cacheStore.item(forKey: id)

    XCTAssertEqual(result, expectedResult)
  }

  func testSetItemWithIdentifiablePublisher_shouldSetItem() {
    let id = UUID()
    let expectedResult = MockCacheItem3(id: id, name: "some_name")

    let promise = expectation(description: "itemForKeyPublisher")
    let cancellable = cacheStore.setItemPublisher(expectedResult)
      .flatMap { [unowned self] _ in
        self.cacheStore.itemPublisher(forKey: id)
    }
    .sink(receiveCompletion: { _ in
      promise.fulfill()
    }, receiveValue: { (result: MockCacheItem3?) in
      XCTAssertEqual(result, expectedResult)
    })

    waitForExpectations(timeout: 5) { error in
      cancellable.cancel()

      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }

}

extension CacheStoreableTests {

  static var allTests = [
    ("testItemForKeyPublisher_whenDoesNotContainItemWithKey_shouldReturnNil",
     testItemForKeyPublisher_whenDoesNotContainItemWithKey_shouldReturnNil),
    ("testItemForKeyPublisher_whenContainsItemWithKey_shouldReturnItem",
     testItemForKeyPublisher_whenContainsItemWithKey_shouldReturnItem),
    ("testItemForKeyPublisher_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil",
     testItemForKeyPublisher_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil),
    ("testItemForKeyPublisher_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem",
     testItemForKeyPublisher_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem),
    ("testItemForKeyPublisher_whenContainsItemWithKeyAndDifferentType_shouldReturnNil",
     testItemForKeyPublisher_whenContainsItemWithKeyAndDifferentType_shouldReturnNil),
    ("testItemForUUIDKeyPublisher_whenDoesNotContainItemWithKey_shouldReturnNil",
     testItemForUUIDKeyPublisher_whenDoesNotContainItemWithKey_shouldReturnNil),
    ("testItemForUUIDKeyPublisher_whenContainsItemWithKey_shouldReturnItem",
     testItemForUUIDKeyPublisher_whenContainsItemWithKey_shouldReturnItem),
    ("testItemForUUIDKeyPublisher_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil",
     testItemForUUIDKeyPublisher_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil),
    ("testItemForUUIDKeyPublisher_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem",
     testItemForUUIDKeyPublisher_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem),
    ("testItemForUUIDKeyPublisher_whenContainsItemWithKeyAndDifferentType_shouldReturnNil",
     testItemForUUIDKeyPublisher_whenContainsItemWithKeyAndDifferentType_shouldReturnNil),
    ("testItemForUUIDKey_whenDoesNotContainItemWithKey_shouldReturnNil",
     testItemForUUIDKey_whenDoesNotContainItemWithKey_shouldReturnNil),
    ("testItemForUUIDKey_whenContainsItemWithKey_shouldReturnItem",
     testItemForUUIDKey_whenContainsItemWithKey_shouldReturnItem),
    ("testItemForUUIDKey_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil",
     testItemForUUIDKey_whenContainsMultipleItemsWithNoneMatchingKey_shouldReturnNil),
    ("testItemForUUIDKey_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem",
     testItemForUUIDKey_whenContainsMultipleItemsWithItemMatchingKey_shouldReturnItem),
    ("testItemForUUIDKey_whenContainsItemWithKeyAndDifferentType_shouldReturnNil",
     testItemForUUIDKey_whenContainsItemWithKeyAndDifferentType_shouldReturnNil),
    ("testRemoveItemForUUIDKey_shouldRemoveItem", testRemoveItemForUUIDKey_shouldRemoveItem),
    ("testRemoveItemForUUIDKey_whenContainsMultipleItems_shouldReturnItem",
     testRemoveItemForUUIDKey_whenContainsMultipleItems_shouldReturnItem),
    ("testRemoveAllForUUIDKey_shouldRemoveAllItems", testRemoveAllForUUIDKey_shouldRemoveAllItems),
    ("testSetItemWithIdentifiable_shouldSetItem", testSetItemWithIdentifiable_shouldSetItem),
    ("testSetItemWithIdentifiablePublisher_shouldSetItem", testSetItemWithIdentifiablePublisher_shouldSetItem)
  ]

}

final class MockCacheStore: CacheStoreable {

  private var dictionary = [String: Codable]()

  func item<Item: Codable>(forKey key: String) -> Item? {
    dictionary[key] as? Item
  }

  @discardableResult
  func setItem<Item: Codable>(_ item: Item, forKey key: String) -> Bool {
    dictionary[key] = item
    return true
  }

  func removeItem(forKey key: String) {
    dictionary[key] = nil
  }

  func removeAll() {
    dictionary.removeAll()
  }

}

private struct MockCacheItem: Codable, Equatable {

  let name: String

}

private struct MockCacheItem2: Codable, Equatable {

  let text: String

}

private struct MockCacheItem3: Codable, Identifiable, Equatable {

  let id: UUID
  let name: String

}
// swiftlint:enable file_length
