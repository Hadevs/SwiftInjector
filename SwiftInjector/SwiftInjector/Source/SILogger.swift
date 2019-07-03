//
//  SILogger.swift
//  SwiftInjector
//
//  Created by Ghost on 03.07.2019.
//  Copyright © 2019 Ghost. All rights reserved.
//

import Foundation

struct SILogger {
  private let prefix: String = "SwiftInjector: "
  enum Priority {
    case low
    case medium
    case high

    var prefix: String {
      switch self {
      case .low, .medium: return ""
      case .high: return "[!IMPORTANT!]:"
      }
    }
  }

  private let text: String

  init(_ text: String) {
    self.text = text
  }

  func log(priority: Priority = .medium) {
    let result = prefix + priority.prefix + " " + text
    print(result)
  }
}
