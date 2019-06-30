//
//  Container.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

class RootContainer: Containerable {
  var container: Containerable?

  var services: [RootContainer.ServiceName : [RootContainer.Service]] = [:]
}
