//
//  CoreDataConvertible.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import CoreData
import Foundation

/// `CoreDataConvertible` is a protocol that establishes a bridge from the client's model object to CoreData's `NSManagedObject`.
/// It allows conversion of model objects into instances of `NSManagedObject` that can be persisted in a CoreData store.
///
/// Implementing this protocol aids in encapsulating the translation between the application's domain model and the persistence layer,
/// promoting separation of concerns and improving the maintainability of the code.
///
/// Conforming to the `CoreDataConvertible` protocol requires specifying one associated type:
///
/// - `ManagedObject`: The type of `NSManagedObject` that this model will be converted into. This type should conform to `ModelConvertible`.
///
/// The `CoreDataConvertible` protocol requires implementing the `convert(in:)` method.
///
/// - `convert(in:)`: A method to convert an instance of this model into an instance of `ManagedObject`.
///   The `NSManagedObjectContext` passed into this function provides the context in which the `NSManagedObject` will be created.
///   It returns the created `ManagedObject`.
///
/// The `@discardableResult` attribute implies that the compiler shouldn't generate a warning if the result of `convert(in:)` isn't used.
public protocol CoreDataConvertible: Identifiable {
  associatedtype ManagedObject: ModelConvertible

  @discardableResult
  func convert(in context: NSManagedObjectContext) -> ManagedObject
}
