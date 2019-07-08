//
//  SwiftInjectorTests.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import XCTest
@testable import SwiftInjector

class ContainerableMainTests: XCTestCase {
  let container = TestContainer()
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExampleRegister() {
    let newVc: ViewController? = container.resolve()
    XCTAssertEqual(container.vc, newVc)
  }

  func testExampleRegister_autoResolving() {
    let newVc: ViewController? = container.resolve()
    let testClass = newVc?.testClass
    print(testClass)
    XCTAssertTrue(true)
  }
}
