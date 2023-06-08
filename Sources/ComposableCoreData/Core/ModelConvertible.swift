//
//  File.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import CoreData
import Foundation

public protocol ModelConvertible: NSManagedObject {
  associatedtype Model: CoreDataConvertible
  associatedtype FetchRequestResult: NSFetchRequestResult
  associatedtype ID: Hashable

  static var entityName: String { get }
  static func fetchRequest(id: ID) -> NSFetchRequest<FetchRequestResult>
  func convert() -> Model
}
