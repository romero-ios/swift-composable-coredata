//
//  DatabaseClient.swift
//
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

/// `DatabaseProviding` is a protocol that defines an interface for basic CRUD (Create, Read, Update, Delete)
/// operations within a database context using the async/await pattern for better readability and error handling.
///
/// This protocol is designed to operate with `CoreDataConvertible` models and their associated `ModelConvertible` records.
/// It provides a common interface to work with data irrespective of the underlying database technology.
///
/// Conforming to the `DatabaseProviding` protocol requires specifying two associated types:
///
/// - `Model`: The type of the client's model object, which should conform to `CoreDataConvertible`.
///   This represents the type of object being managed in the database.
///
/// - `Record`: The type of the `NSManagedObject` subclass, which should conform to `ModelConvertible` and
///   be convertible to the `Model` type.
///
/// The `DatabaseProviding` protocol requires implementing four properties:
///
/// - `fetch`: An asynchronous function which, when called, fetches all instances of `Model` from the database and
///   returns them as an array. It throws an error if the fetch operation fails.
///
/// - `create`: An asynchronous function which, when called with an instance of `Model`, creates a corresponding
///   `Record` in the database. It throws an error if the create operation fails.
///
/// - `delete`: An asynchronous function which, when called with an instance of `Model`, deletes the corresponding
///   `Record` from the database. It throws an error if the delete operation fails.
///
/// - `update`: An asynchronous function which, when called with an instance of `Model`, updates the corresponding
///   `Record` in the database. It throws an error if the update operation fails.
public protocol DatabaseProviding {
  associatedtype Model: CoreDataConvertible
  associatedtype Record: ModelConvertible where Record.Model == Model
  
  var fetch: () async throws -> [Record.Model] { get set }
  var create: (Model) async throws -> Void { get set }
  var delete: (Model) async throws -> Void { get set }
  var update: (Model) async throws -> Void { get set }
}
