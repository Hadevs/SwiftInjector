//
//  Containerable.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

protocol Containerable: class {
  typealias ServiceName = String
  typealias Service = (() -> Any)
  var container: Containerable? { get set }

  var services: [ServiceName: [Service]] { get set }
}

extension Containerable {
  func resolve<T>() -> T? {
    let key = String(describing: T.self)

    let array = services[key]
    return array?.first?() as? T
  }

  func register<T: Any>(_ registration: @escaping (() -> T)) {
    let object = registration()
    let key = String(describing: type(of: object))
    if let array = services[key] {
      var newArray = array
      newArray.append(registration)
      services[key] = newArray
    } else {
      services[key] = [registration]
    }
  }
}
