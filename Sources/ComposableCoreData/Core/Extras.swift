//
//  File.swift
//
//
//  Created by Daniel Romero on 9/28/23.
//

import Foundation

public indirect enum FilterType {
    case equals(String, Any)
    case notEquals(String, Any)
    case greaterThan(String, Any)
    case lessThan(String, Any)
    case greaterThanOrEqual(String, Any)
    case lessThanOrEqual(String, Any)
    case contains(String, String)
    case beginsWith(String, String)
    case endsWith(String, String)
    case inSet(String, [Any])
    case between(String, Any, Any)
    case isNil(String)
    case isNotNil(String)
    case and([FilterType])
    case or([FilterType])
    case not(FilterType)

    public func predicate() -> NSPredicate {
        switch self {
        case .equals(let key, let value):
            return NSPredicate(format: "%K == %@", key, value as! NSObject)
        case .notEquals(let key, let value):
            return NSPredicate(format: "%K != %@", key, value as! NSObject)
        case .greaterThan(let key, let value):
            return NSPredicate(format: "%K > %@", key, value as! NSObject)
        case .lessThan(let key, let value):
            return NSPredicate(format: "%K < %@", key, value as! NSObject)
        case .greaterThanOrEqual(let key, let value):
            return NSPredicate(format: "%K >= %@", key, value as! NSObject)
        case .lessThanOrEqual(let key, let value):
            return NSPredicate(format: "%K <= %@", key, value as! NSObject)
        case .contains(let key, let value):
            return NSPredicate(format: "%K CONTAINS %@", key, value)
        case .beginsWith(let key, let value):
            return NSPredicate(format: "%K BEGINSWITH %@", key, value)
        case .endsWith(let key, let value):
            return NSPredicate(format: "%K ENDSWITH %@", key, value)
        case .inSet(let key, let values):
            return NSPredicate(format: "%K IN %@", key, values as NSObject)
        case .between(let key, let minValue, let maxValue):
            return NSPredicate(format: "(%K >= %@) AND (%K <= %@)", key, minValue as! NSObject, key, maxValue as! NSObject)
        case .isNil(let key):
            return NSPredicate(format: "%K == nil", key)
        case .isNotNil(let key):
            return NSPredicate(format: "%K != nil", key)
        case .and(let filters):
            let subpredicates = filters.map { $0.predicate() }
            return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        case .or(let filters):
            let subpredicates = filters.map { $0.predicate() }
            return NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        case .not(let filter):
            return NSCompoundPredicate(notPredicateWithSubpredicate: filter.predicate())
        }
    }
}

public struct Filter {
  public let predicate: NSPredicate
  
  public init(type: FilterType) {
    self.predicate = type.predicate()
  }
  
  public init(customPredicate: NSPredicate) {
    self.predicate = customPredicate
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

