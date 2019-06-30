//
//  TestContainer.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class TestContainer: DIContainer {
  let vc = ViewController()
  override func register() {
    register {
      return self.vc
    }
  }
}
