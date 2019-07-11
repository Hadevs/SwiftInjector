//
//  ContainerableProtocolTest.swift
//  SwiftInjectorTests
//
//  Created by Ghost on 10.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import XCTest
@testable import SwiftInjector

class ContainerableProtocolTests: XCTestCase {

  override func setUp() {

  }

  func testExampleProtocolInheritance() {
    let containerable: Containerable = RootContainer()
    containerable.register ({ ProtocolViewController() })
    containerable.register ({ ProtocolTestClass() })
    let vc: ProtocolViewController? = containerable.resolve()
    XCTAssertNotNil(vc) 
    let testClass = containerable.resolve(objectType: TestClassProtocol.self)
    
    XCTAssertNotNil(testClass)

    XCTAssertNotNil(vc?.testClass)
    XCTAssertEqual(containerable.memmoryAddress(vc?.testClass as AnyObject), containerable.memmoryAddress(testClass! as AnyObject))

  }
}

