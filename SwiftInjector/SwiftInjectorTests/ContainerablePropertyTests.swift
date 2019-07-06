//
//  ContainerablePropertyTests.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 06.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import XCTest
@testable import SwiftInjector

class ContainerablePropertyTests: XCTestCase {

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testPropertyNil() {
    let container: Containerable = RootContainer()
    let object = TestClass()
    let property: String? = container.property(object: object, propertyName: "name1")
    XCTAssertNil(property)
  }

  func testPropertyNotNil() {
    let container: Containerable = RootContainer()
    let object = TestClass()
    let property: String? = container.property(object: object, propertyName: "name")
    XCTAssertNotNil(property)
    XCTAssertEqual(property, "123")
  }
}
