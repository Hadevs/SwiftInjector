//
//  Container.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

protocol Container: class {
  var parentContainer: Containerable { get set }
  func register()
}

extension Container {
  func resolve<T>() -> T? {
    return parentContainer.resolve()
  }
}
