//
//  DatabaseClient.swift
//
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

public enum DatabaseProviderError: Error {
  case fetchFailure(message: String)
  case deleteFailure(message: String)
  case updateFailure(message: String)
}

public protocol DatabaseProviding {
  associatedtype Model: CoreDataConvertible
  associatedtype Record: ModelConvertible where Record.Model == Model
  
  var fetch: () async throws -> [Record.Model] { get set }
  var create: (Model) async throws -> Void { get set }
  var delete: (Model) async throws -> Void { get set }
  var update: (Model) async throws -> Void { get set }
}

/// A basic struct that provides CRUD operations for any `Model` and `Record` who share the same `ID`.
public struct DatabaseClient<Model: CoreDataConvertible, Record: ModelConvertible>: DatabaseProviding where Record.Model == Model {
  public var fetch: () async throws -> [Record.Model]
  public var create: (Model) async throws -> Void
  public var delete: (Model) async throws -> Void
  public var update: (Model) async throws -> Void
  
  public init(
    fetch: @escaping () async throws -> [Record.Model],
    create: @escaping (Model) async throws -> Void,
    delete: @escaping (Model) async throws -> Void,
    update: @escaping (Model) async throws -> Void
  )
  {
    self.fetch = fetch
    self.create = create
    self.delete = delete
    self.update = update
  }
}
