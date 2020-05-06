//
//  XCTestManifests.swift
//  CacheTests
//
//  Created by Adam Young on 01/10/2019.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(CacheStoreTests.allTests),
    testCase(DiskCacheStoreTests.allTests),
    testCase(MemoryCacheStoreTests.allTests)
  ]
}
#endif
