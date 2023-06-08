//
//  CoreDataConvertible.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import CoreData
import Foundation

public protocol CoreDataConvertible: Identifiable {
  associatedtype ManagedObject: ModelConvertible

  @discardableResult
  func convert(in context: NSManagedObjectContext) -> ManagedObject
}
