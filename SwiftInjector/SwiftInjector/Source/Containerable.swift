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
  var name: String? = nil
  var registration: Containerable.Service
  var object: Containerable.Object? = nil
  init(_ registration: @escaping Containerable.Service, name: String? = nil) {
    self.registration = registration
    self.name = name
  }
}

extension Containerable {
  private func resolveAny(typeString: String, name: String? = nil) -> Object? {
    // TODO: replace .first with more smart condition
    let array: [ContainerObject]? = {
      if let filterName = name {
        return services[typeString]?.filter { $0.name == filterName }
      } else {
        return services[typeString]
      }
    }()

    if (array?.count ?? 0) > 1 {
      SILogger("Warning in \(typeString) resolving. You registered two different object for this type. Try to provide \"name\" argument while registering your object. But you will receive first object of all services you registered.").log()
    }

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

  func resolve<T: Object>(name: String? = nil) -> T? {
    let key = String(describing: T.self)
    let object = resolveAny(typeString: key, name: name) as? T
    
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

  func register<T: Object>(_ registration: @escaping (() -> T), name: String? = nil) {

    dispatchRegistrationGroup.enter()
    let object = registration()
    let key = String(describing: type(of: object))
    if let array = services[key] {
      var newArray = array
      newArray.append(ContainerObject(registration, name: name))
      services[key] = newArray
    } else {
      services[key] = [ContainerObject(registration, name: name)]
    }
    dispatchRegistrationGroup.leave()
  }
}
