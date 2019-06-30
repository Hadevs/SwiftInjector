//
//  Containerable.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

protocol Containerable: class {
  typealias Object = AnyObject
  typealias ServiceName = String
  typealias Service = (() -> Object)
  var container: Containerable? { get set }
  var dispatchRegistrationGroup: DispatchGroup { get }

  var services: [ServiceName: [ContainerObject]] { get set }
}

struct ContainerObject {
  var registration: Containerable.Service
  var object: Containerable.Object? = nil
  init(_ registration: @escaping Containerable.Service) {
    self.registration = registration
  }
}

extension Containerable {
  private func resolveAny(typeString: String) -> Object? {
    // TODO: replace .first with more smart condition
    let array = services[typeString]
    if let object = array?.first?.object {
      autoresolve(on: object)
      return object
    } else if let object = array?.first?.registration() {
      var objects = services[typeString]
      if objects?.count ?? 0 > 0 {
        objects?[0].object = object
      }
      services[typeString] = objects ?? []
      autoresolve(on: object)
      return object
    } else {
      return nil
    }
  }

  func resolve<T: Object>() -> T? {
    let key = String(describing: T.self)
    let object = resolveAny(typeString: key) as? T
    
    return object
  }

  private func autoresolve<T: Object>(on object: T) {
    let mirror = Mirror(reflecting: object)
    for attr in mirror.children {
      if let property_name = attr.label {
        let objectType = type(of: attr.value)
        let typeString = String(describing: objectType).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
        if let ivar = class_getInstanceVariable(type(of: object), property_name) {
          print(type(of: object), mirror.children.map { $0.label })
          if let value = resolveAny(typeString: typeString) {
            object_setIvar(object, ivar, value)
          }
        }
      }
    }
  }

  func register<T: Object>(_ registration: @escaping (() -> T)) {
    dispatchRegistrationGroup.enter()
    let object = registration()
    let key = String(describing: type(of: object))
    if let array = services[key] {
      var newArray = array
      newArray.append(ContainerObject(registration))
      services[key] = newArray
    } else {
      services[key] = [ContainerObject(registration)]
    }
    dispatchRegistrationGroup.leave()
  }
}
