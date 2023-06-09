//
//  File.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import CoreData
import Foundation

/// `ModelConvertible` is a protocol that establishes a bridge between CoreData's `NSManagedObject` and
/// the client's model object. It introduces a mechanism to convert `NSManagedObject` instances into instances of the
/// client's model and provides a fetch request operation based on an ID.
///
/// This protocol also links the Core Data layer with the app's domain layer, aiding the implementation of
/// persistence and retrieval operations in a clean, manageable way.
///
/// Conforming to the `ModelConvertible` protocol requires specifying two associated types:
///
/// - `Model`: The type of the client's model object, which should conform to `CoreDataConvertible`. This represents
///   the "swiftified", more usable representation of the data that the `NSManagedObject` is encapsulating.
///
/// - `ID`: The type that is used as the unique identifier of the model. This should be hashable to ensure
///   uniqueness and comparability.
///
/// The `ModelConvertible` protocol requires implementing the `entityName` static property, the `fetchRequest(id:)`
/// static method, and the `convert()` instance method.
///
/// - `entityName`: The name of the Core Data entity that corresponds to this type.
///
/// - `fetchRequest(id:)`: A method to create a fetch request for an object of this type. This method should return
///   an `NSFetchRequest` for objects of this type with the specified ID.
///
/// - `convert()`: A method to convert an instance of this type (an `NSManagedObject`) into an instance of `Model`.
public protocol ModelConvertible: NSManagedObject {
  associatedtype Model: CoreDataConvertible
  associatedtype ID: Hashable

  static var entityName: String { get }
  static func fetchRequest(id: ID) -> NSFetchRequest<Self>
  func convert() -> Model
}

extension ModelConvertible where ID == UUID {
  public static func fetchRequest(id: ID) -> NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: Self.entityName)
    request.predicate = .init(format: "id == %@", id as CVarArg)
    return request
  }
}

extension ModelConvertible where ID == Int {
  public static func fetchRequest(id: Int) -> NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: Self.entityName)
    request.predicate = .init(format: "id == %@", id)
    return request
  }
}

extension ModelConvertible where ID == Date {
  public static func fetchRequest(id: Date) -> NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: Self.entityName)
    request.predicate = .init(format: "id == %@", id as CVarArg)
    return request
  }
}
