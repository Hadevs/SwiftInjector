//
//  TestClass.swift
//  SwiftInjector
//
//  Created by Ghost on 01.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class TestClass: Equatable {
  var name: String = "123"
  weak var viewController: ViewController?

  static func == (lhs: TestClass, rhs: TestClass) -> Bool {
    return "\(Unmanaged.passUnretained(lhs).toOpaque())" == "\(Unmanaged.passUnretained(rhs).toOpaque())"
  }
}


//protocol TestClassable {
//
//}
//
//class VC1 {
//  var testClassable: TestClassable?
//}
//
//class ProtocoledTestClass: TestClass {
//  var name: String = "123"
//  weak var viewController: TestClassable?
//
//  static func == (lhs: TestClass, rhs: TestClass) -> Bool {
//    return "\(Unmanaged.passUnretained(lhs).toOpaque())" == "\(Unmanaged.passUnretained(rhs).toOpaque())"
//  }
//}
