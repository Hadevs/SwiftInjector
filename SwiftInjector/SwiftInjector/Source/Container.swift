//
//  Container.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class Container: Containerable {
  var container: Containerable

  required init(container: Containerable) {
    self.container = container
  }

  var services: [String : [Any]] = [:]
}
