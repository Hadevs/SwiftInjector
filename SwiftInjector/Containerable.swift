//
//  Containerable.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

public protocol Containerable: class {
  typealias Object = AnyObject
  typealias ServiceName = String
  typealias Service = (() -> Object)
  typealias RelationIn = String
  typealias RelationOut = String

  var dispatchRegistrationGroup: DispatchGroup { get }

  var services: [ServiceName: [ContainerObject]] { get set }
  var relations: [RelationIn: [RelationOut]] { get set }
  var recursiveNotResolvedObjects: [Object] { get set }
}

public struct ContainerObject {
  public enum RegistrationType {
    case manual
    case automatic
  }
  var name: String? = nil
  var registrationType: RegistrationType
  var registration: Containerable.Service
  var object: Containerable.Object? = nil
  var type: Containerable.Object.Type
  init(_ registration: @escaping Containerable.Service,
       name: String? = nil,
       registrationType: RegistrationType,
       objectType: Containerable.Object.Type) {
    self.registration = registration
    self.name = name
    self.registrationType = registrationType
    self.type = objectType
  }
}


//MARK: TODO: MOVE IT TO DIContainer.swift
public extension Containerable {
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
      print(1)
      return object
    } else if let object = array?.first?.registration() {

      var objects = services[typeString]
      if objects?.count ?? 0 > 0 {
        objects?[0].object = object
      }

      services[typeString] = objects ?? []
      if array?.first?.registrationType == .automatic {
        autoresolve(on: object)
        finishRegistrations()
      }

      return object
    } else {
      // There is no object with this protocol. (if it's really a protocol) Let's find out first class, conformable to protocol

      for service in services {
        for object in service.value {

          let isConforms = (object.object as? TestClassProtocol) != nil || (object.registration() as? TestClassProtocol) != nil
          if isConforms {
            return resolveAny(typeString: service.key, name: name)
          }
        }
      }

      return nil
    }
  }

  func resolve<T>(name: String? = nil, objectType: T.Type? = nil) -> T? {
    let key = String(describing: T.self)
//    let protocolToResolve: Protocol? = objectType
    let object = resolveAny(typeString: key, name: name) as? T
    
    return object
  }


  func finishRegistrations() {
    relations = [:]
    for object in recursiveNotResolvedObjects {
      autoresolve(on: object)
    }
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

  func memmoryAddress(_ object: Object) -> String {
    return "\(Unmanaged.passUnretained(object).toOpaque())"
  }


  // MARK: *TODO: Unable to test*
  private func recordRelations(relationIn: RelationIn, relationOut: RelationOut) {
    if let relationsOut = relations[relationIn], !relationsOut.contains(relationOut) {
      var newRelationsOut = relationsOut
      newRelationsOut.append(relationOut)
      relations[relationIn] = newRelationsOut
    } else {
      relations[relationIn] = [relationOut]
    }
  }

  // MARK: *TESTED*
  func formattedString<T: Object>(of object: T) -> String {
    return String(describing: type(of: object)).replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
  }

  // MARK: *TESTED*
  func property<T>(object: Object, propertyName: String) -> T? {
    let mirror = Mirror(reflecting: object)
    for attr in mirror.children {
      if attr.label == propertyName {
        return attr.value as? T
      }
    }

    return nil
  }

  // MARK: *TESTED*
  // Returns only first variable of type
  func propertyName(by typeString: String, in object: Object) -> String? {
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

  // MARK: *TESTED*
  func register<T: Object>(_ registration: @escaping (() -> T),
                           name: String? = nil,
                           registrationType: ContainerObject.RegistrationType = .automatic) {
    dispatchRegistrationGroup.enter()
    let object = registration()
    let key = String(describing: type(of: object))
    if let array = services[key] {
      var newArray = array
      newArray.append(ContainerObject(registration,
                                      name: name,
                                      registrationType: registrationType,
                                      objectType: T.self))
      services[key] = newArray
    } else {
      services[key] = [ContainerObject(registration,
                                       name: name,
                                       registrationType: registrationType,
                                       objectType: T.self)]
    }
    dispatchRegistrationGroup.leave()
  }
}
