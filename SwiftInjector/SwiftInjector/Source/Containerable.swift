//
//  Containerable.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

protocol Containerable: class {
  var container: Containerable? { get set }

  var services: [String: [Any]] { get set }
}

extension Containerable {
  func resolve<T>() -> T? {
    let key = String(describing: T.self)
    
    let array = services[key] as? [T]
    return array?.first
  }

  func register<T: Any>(_ object: T) {
    let key = String(describing: type(of: object))
    if let array = services[key] {
      var newArray = array
      newArray.append(object)
      services[key] = newArray
    } else {
      services[key] = [object]
    }
  }
}
