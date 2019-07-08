//
//  ContrainerableManualRegistrationTests.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 08.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//



import XCTest
@testable import SwiftInjector

class ContainerableManualRegistrationTests: XCTestCase {
  override func setUp() {

  }

  func testManualRegistrationSample() {
    let contaienrable: Containerable = RootContainer()
    contaienrable.register({ () -> ViewController in
      let vc = ViewController()
      vc.testClass = TestClass()
      return vc
    }, registrationType: .manual)

    let vc: ViewController? = contaienrable.resolve()
    XCTAssertNotNil(vc)
    XCTAssertNotNil(vc?.testClass)
    let testClass: TestClass? = contaienrable.resolve()
    XCTAssertNil(testClass)
  }
}

