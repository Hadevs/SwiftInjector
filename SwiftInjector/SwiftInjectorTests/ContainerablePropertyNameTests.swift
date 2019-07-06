//
//  ContainerablePropertyName.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 06.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//


import XCTest
@testable import SwiftInjector

class ContainerablePropertyNameTests: XCTestCase {
  let container: Containerable = RootContainer()

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testPropertyNameWithOneString() {
    class Test {
      var name: String = "123"
    }
    let typeString = "String"
    let name = container.propertyName(by: typeString, in: Test())
    XCTAssertEqual(name, "name")
  }

  func testPropertyNameWithTwoStrings() {
    class Test {
      var name: String = "123"
      var test: String = "456"
    }
    let typeString = "String"
    let name = container.propertyName(by: typeString, in: Test())
    XCTAssertEqual(name, "name")
  }

  func testPropertyNameWithTest() {
    class Test {
      var test: Test?
    }
    let typeString = "Test"
    let name = container.propertyName(by: typeString, in: Test())
    XCTAssertEqual(name, "test")
  }
}

