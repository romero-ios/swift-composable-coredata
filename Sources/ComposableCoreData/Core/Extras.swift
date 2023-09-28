//
//  File.swift
//
//
//  Created by Daniel Romero on 9/28/23.
//

import Foundation

public enum Filter {
  case equals(String, Encodable)
  case notEquals(String, Encodable)
  // Add more cases as needed
  
  func predicate() -> NSPredicate {
    switch self {
    case .equals(let key, let value):
      return NSPredicate(format: "\(key) == %@", value as! NSObject)
    case .notEquals(let key, let value):
      return NSPredicate(format: "\(key) != %@", value as! NSObject)
    }
  }
}

public enum SortDescriptor {
  case ascending(String)
  case descending(String)
  
  func sortDescriptor() -> NSSortDescriptor {
    switch self {
    case .ascending(let key):
      return NSSortDescriptor(key: key, ascending: true)
    case .descending(let key):
      return NSSortDescriptor(key: key, ascending: false)
    }
  }
}

