//
//  DIContainer.swift
//  SwiftInjector
//
//  Created by Ghost on 30.06.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

open class DIContainer: Container {
  open var parentContainer: Containerable

  public init(parentContainer: Containerable? = nil) {
    self.parentContainer = parentContainer ?? RootContainer()
    self.register()
  }

  public final func register<T: Containerable.Object>(registrationType: ContainerObject.RegistrationType = .automatic,
                                               name: String? = nil,
                                               _ registration: @escaping (() -> T)) {
    parentContainer.register(registration, name: name, registrationType: registrationType)
  }

  public final func resolve<T: Containerable.Object>(name: String? = nil) -> T? {
    return parentContainer.resolve(name: name)
  }

  open func register() {
    // Mark: leave empty only in this class
  }
}
