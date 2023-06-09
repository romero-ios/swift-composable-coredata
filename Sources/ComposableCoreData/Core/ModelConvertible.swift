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

extension ModelConvertible where ID == UUID {
  public static func fetchRequest(id: ID) -> NSFetchRequest<FetchRequestResult> {
    let request = NSFetchRequest<Self.FetchRequestResult>(entityName: Self.entityName)
    request.predicate = .init(format: "id == %@", id as CVarArg)
    return request
  }
}

extension ModelConvertible where ID == Int {
  public static func fetchRequest(id: Int) -> NSFetchRequest<FetchRequestResult> {
    let request = NSFetchRequest<Self.FetchRequestResult>(entityName: Self.entityName)
    request.predicate = .init(format: "id == %@", id)
    return request
  }
}

extension ModelConvertible where ID == Date {
  public static func fetchRequest(id: Date) -> NSFetchRequest<FetchRequestResult> {
    let request = NSFetchRequest<Self.FetchRequestResult>(entityName: Self.entityName)
    request.predicate = .init(format: "id == %@", id as CVarArg)
    return request
  }
}

public protocol Transformable {
  associatedtype Model: NSSecureCoding
  
  func transform() -> Model
}
