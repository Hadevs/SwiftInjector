//
//  Container.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class RootContainer: Containerable {
  var recursiveNotResolvedObjects: [Object] = []

  var relations: [RelationIn: [RelationOut]] = [:]
  var services: [ServiceName: [ContainerObject]] = [:]

  var dispatchRegistrationGroup: DispatchGroup = DispatchGroup()

  var container: Containerable?

  init() {
    let date = Date()
    dispatchRegistrationGroup.notify(queue: .main) {

      self.finishRegistrations()
      let seconds = Date().timeIntervalSince(date)
      print("All properties have been successfully injected for \(seconds) seconds.")
    }
  }
}
