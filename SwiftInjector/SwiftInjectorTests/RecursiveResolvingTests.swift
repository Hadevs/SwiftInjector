//
//  SwiftInjectorTests.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import XCTest
@testable import SwiftInjector

class RecursiveResolvingTests: XCTestCase {


  class FirstClass: Equatable {
    var name: String = "123"
    var secondClass: SecondClass!

    static func == (lhs: FirstClass, rhs: FirstClass) -> Bool {
      return "\(Unmanaged.passUnretained(lhs).toOpaque())" == "\(Unmanaged.passUnretained(rhs).toOpaque())"
    }
  }

  class SecondClass: Equatable {
    var name: String = "234"
    weak var firstClass: FirstClass!

    static func == (lhs: SecondClass, rhs: SecondClass) -> Bool {
      return "\(Unmanaged.passUnretained(lhs).toOpaque())" == "\(Unmanaged.passUnretained(rhs).toOpaque())"
    }

  }

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  let container = TestContainer()

  func testClassToClassRegister() {
    let firstClass: ViewController? = container.resolve()
    let secondClass: TestClass? = container.resolve()
    print("---------")
    print("---------")
    XCTAssertNotNil(firstClass)
    XCTAssertNotNil(secondClass)
    XCTAssertNotNil(secondClass?.viewController)
    XCTAssertEqual(secondClass?.viewController, firstClass)
    XCTAssertEqual(firstClass?.testClass, secondClass)
  }
}
