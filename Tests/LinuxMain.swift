//
//  XCTestManifests.swift
//  Cache
//
//  Created by Adam Young on 01/10/2019.
//

import CacheTests
import XCTest

var tests = [XCTestCaseEntry]()
tests += CacheTests.allTests()
XCTMain(tests)
