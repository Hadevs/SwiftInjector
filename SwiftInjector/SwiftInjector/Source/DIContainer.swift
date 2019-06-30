//
//  DIContainer.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class DIContainer: Container {
  var parentContainer: Containerable

  init(parentContainer: Containerable? = nil) {
    self.parentContainer = parentContainer ?? RootContainer()
  }

  final func register<T: Any>(_ object: T) {
    parentContainer.register(object)
  }

  final func resolve<T>() -> T? {
    return parentContainer.resolve()
  }

  func register() {
    // Mark: leave empty only in this class
  }
}
