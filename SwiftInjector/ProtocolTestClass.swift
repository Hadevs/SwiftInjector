//
//  ProtocolTestClass.swift
//  SwiftInjector
//
//  Created by Ghost on 11.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

protocol TestClassProtocol {

}

class ProtocolTestClass: TestClassProtocol, Equatable {
  static func == (lhs: ProtocolTestClass, rhs: ProtocolTestClass) -> Bool {
    return "\(Unmanaged.passUnretained(lhs).toOpaque())" == "\(Unmanaged.passUnretained(rhs).toOpaque())"
  }
}
