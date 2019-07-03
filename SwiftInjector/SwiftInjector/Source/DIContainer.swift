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
    self.register()
  }

  final func register<T: Containerable.Object>(name: String? = nil, _ registration: @escaping (() -> T)) {
    parentContainer.register(registration, name: name)
  }

  final func resolve<T: Containerable.Object>(name: String? = nil) -> T? {
    return parentContainer.resolve(name: name)
  }

  func register() {
    // Mark: leave empty only in this class
  }
}
