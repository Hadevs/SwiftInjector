//
//  ContainerableRegister.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 06.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import XCTest
@testable import SwiftInjector

class ContainerableRegisterTests: XCTestCase {

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExampleRegisterWithoutResolving() {
    let container: Containerable = RootContainer()
    let object = TestClass()
    container.register({ () -> TestClass in
      return object
    }, name: nil)

    let key = String(describing: type(of: object))
    XCTAssertNotNil(container.services[key])
    XCTAssert(container.services[key]?.count ?? 0 == 1)

    let containerObject = container.services[key]?.first
    XCTAssertNil(containerObject?.object)
    // it cannot be exists, because it has been not resolved yet
  }

  func testExampleRegisterWithResolving() {
    let container: Containerable = RootContainer()
    let object = TestClass()
    container.register({ () -> TestClass in
      return object
    }, name: nil)

    let key = String(describing: type(of: object))
    XCTAssertNotNil(container.services[key])
    XCTAssert(container.services[key]?.count ?? 0 == 1)

    let obj: TestClass? = container.resolve()
    XCTAssertNotNil(obj)
    let containerObject = container.services[key]?.first
    XCTAssertNotNil(containerObject?.object)
    XCTAssert(containerObject?.object is TestClass)
    XCTAssertEqual(containerObject?.object as? TestClass, object)
  }
}

