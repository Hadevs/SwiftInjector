//
//  Container.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class RootContainer: Containerable {
  var services: [ServiceName : [ContainerObject]] = [:]

  var dispatchRegistrationGroup: DispatchGroup = DispatchGroup()

  var container: Containerable?

  init() {
    dispatchRegistrationGroup.notify(queue: .main) {
      print("All properties have been successfully injected.")
    }
  }
}
