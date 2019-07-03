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
  typealias RelationIn = String
  typealias RelationOut = String

  var container: Containerable? { get set }
  var dispatchRegistrationGroup: DispatchGroup { get }

  var services: [ServiceName: [ContainerObject]] { get set }
  var relations: [RelationIn: [RelationOut]] { get set }
  var recursiveNotResolvedObjects: [Object] { get set }
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
    let array: [ContainerObject]? = {
      if let filterName = name {
        return services[typeString]?.filter { $0.name == filterName }
      } else {
        return services[typeString]
      }
    }()

    if (array?.count ?? 0) > 1 {
      SILogger("Warning in \(typeString) resolving. You registered two different objects for this type. Try to provide \"name\" argument while registering your object. But you will receive first object of all services you registered.").log(priority: .high)
    }

    if let object = array?.first?.object {
      return object
    } else if let object = array?.first?.registration() {

      var objects = services[typeString]
      if objects?.count ?? 0 > 0 {
        objects?[0].object = object
      }

      services[typeString] = objects ?? []
      autoresolve(on: object)
      finishRegistrations()

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

  func finishRegistrations() {
    relations = [:]
    for object in recursiveNotResolvedObjects {
      autoresolve(on: object)
    }
    recursiveNotResolvedObjects.removeAll()
  }

  private func autoresolve<T: Object>(on object: T) {
    let mirror = Mirror(reflecting: object)

    for attr in mirror.children {
      if let property_name = attr.label {
        let objectType = type(of: attr.value)
        let typeString = String(describing: objectType).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")

        // MARK: MUTATE VARIABLE (DANGER OBJC RUNTIME ZONE)
        if let ivar = class_getInstanceVariable(type(of: object), property_name) {
          let typeStringOfMyObject = formattedString(of: object)
          recordRelations(relationIn: typeString, relationOut: typeStringOfMyObject)
          if relations[typeStringOfMyObject]?.contains(typeString) ?? false {
            relations[typeString]?.removeAll(where: { (string) -> Bool in
              return string == typeStringOfMyObject
            })
            recursiveNotResolvedObjects.append(object)
            return
          }
          if let value = resolveAny(typeString: typeString) {
            object_setIvar(object, ivar, value)
          }
        }
      }
    }
  }

  private func memmoryAddress(_ object: Object) -> String {
    return "\(Unmanaged.passUnretained(object).toOpaque())"
  }

  private func recordRelations(relationIn: RelationIn, relationOut: RelationOut) {
    if let relationsOut = relations[relationIn], !relationsOut.contains(relationOut) {
      var newRelationsOut = relationsOut
      newRelationsOut.append(relationOut)
      relations[relationIn] = newRelationsOut
    } else {
      relations[relationIn] = [relationOut]
    }
  }

  private func formattedString<T: Object>(of object: T) -> String {
    return String(describing: type(of: object)).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
  }

  private func doesObjectHas(object: Object, propertyType: String) -> Bool {
    let mirror = Mirror(reflecting: object)
    for attr in mirror.children {
      let objectType = type(of: attr.value)
      let typeString = String(describing: objectType).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
      if typeString == typeString {
        return true
      }
    }

    return false
  }

  private func property<T>(object: Object, propertyName: String) -> T? {
    let mirror = Mirror(reflecting: object)
    for attr in mirror.children {
      if attr.label == propertyName {
        return attr.value as? T
      }
    }

    return nil
  }

  private func propertyName(by typeString: String, in object: Object) -> String? {
    let mirror = Mirror(reflecting: object)
    for attr in mirror.children {
      let propertyType = type(of: attr.value)
      let typeStringInside = String(describing: propertyType).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
      if typeStringInside == typeString {
        return attr.label
      }
    }

    return nil
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
