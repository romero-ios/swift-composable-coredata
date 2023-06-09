//
//  ValueFetchedDatabaseClient.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

public protocol ValueFetchedDatabaseProviding: DatabaseProviding {
    associatedtype HashableType: Hashable

    var fetchAllByValue: (HashableType) async throws -> [Record.Model] { get set }
    var fetchForValue: (HashableType) async throws -> Record.Model { get set }
}

public struct ValueFetchedDatabaseClient<Model: CoreDataConvertible, Record: ModelConvertible, HashableType: Hashable>: ValueFetchedDatabaseProviding where Record.Model == Model {
  public var fetch: () async throws -> [Record.Model]
  public var create: (Model) async throws -> Void
  public var delete: (Model) async throws -> Void
  public var update: (Model) async throws -> Void
  public var fetchAllByValue: (HashableType) async throws -> [Record.Model]
  public var fetchForValue: (HashableType) async throws -> Record.Model

    public init(
        fetch: @escaping () async throws -> [Record.Model],
        create: @escaping (Model) async throws -> Void,
        delete: @escaping (Model) async throws -> Void,
        update: @escaping (Model) async throws -> Void,
        fetchAllByValue: @escaping (HashableType) async throws -> [Record.Model],
        fetchForValue: @escaping (HashableType) async throws -> Record.Model
    ) {
        self.fetch = fetch
        self.create = create
        self.delete = delete
        self.update = update
        self.fetchAllByValue = fetchAllByValue
        self.fetchForValue = fetchForValue
    }
}
