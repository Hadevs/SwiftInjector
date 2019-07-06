//
//  ContainerableFormattedStringTests.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 06.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import XCTest
@testable import SwiftInjector

class ContainerableFormattedStringTests: XCTestCase {
  let container = TestContainer()
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExampleRegister() {
    let containerable: Containerable = RootContainer()
    let object = TestClass()
    let objectTypeString = containerable.formattedString(of: object)
    XCTAssertEqual(objectTypeString, "TestClass")
  }

  func testExampleRegisterInvalid() {
    let containerable: Containerable = RootContainer()
    let object = TestClass()
    let objectTypeString = containerable.formattedString(of: object)
    XCTAssertNotEqual(objectTypeString, "TestClass1")
  }
}

