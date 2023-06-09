//
//  ValueFetchedDatabaseClient+Live.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import CoreData
import Foundation

public struct ValueFetchedDatabaseClient<Model: CoreDataConvertible, Record: ModelConvertible, HashableType: Hashable>: ValueFetchedDatabaseProviding where Record.Model == Model {
  public var fetch: () async throws -> [Record.Model]
  public var create: (Model) async throws -> Void
  public var delete: (Model) async throws -> Void
  public var update: (Model) async throws -> Void
  public var fetchAllByValue: (HashableType) async throws -> [Record.Model]
  public var fetchForValue: (HashableType) async throws -> Record.Model
  
  fileprivate init(
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

extension ValueFetchedDatabaseClient where Model.ID == Record.ID {
  /// This extension provides an implementation of `ValueFetchedDatabaseClient` where `Model.ID` equals `Record.ID`.
  /// It extends the functionality of `DatabaseClient` by adding two new methods: `fetchAllByValue` and `fetchForValue`.
  /// For details on the methods inherited from `DatabaseClient`, refer to its documentation.
  ///
  ///
  /// - `fetchAllByValue`: `(HashableType) async throws -> [Record.Model]`
  ///   An async function accepting a Hashable value and intended to fetch all corresponding `Record.Model` instances.
  ///   **This function must be overridden in an extension; calling it directly will result in a fatal error**.
  ///
  /// - `fetchForValue`: `(HashableType) async throws -> Record.Model`
  ///   An async function accepting a Hashable value and intended to fetch a specific `Record.Model` instance.
  ///   **This function must be overridden in an extension; calling it directly will result in a fatal error**.
  public static func live(persistentContainer: NSPersistentContainer) -> Self {
    return .init(
      fetch: {
        let context = persistentContainer.newBackgroundContext()
        return try await withCheckedThrowingContinuation { continuation in
          let request = Record.fetchRequest()
          do {
            let models = try context.fetch(request)
              .map { ($0 as! Record).convert() }
            continuation.resume(returning: models)
          } catch {
            continuation.resume(throwing: DatabaseProviderError.fetchFailure(message: "Unable to fetch \(String(describing: type(of: Record.self)))"))
          }
        }
      },
      create: { model in
        return try await persistentContainer.performBackgroundTask { context in
          model.convert(in: context)
          try context.save()
        }
      },
      delete: { model in
        try await persistentContainer.performBackgroundTask { context in
          let request = Record.fetchRequest(id: model.id)
          let models = try context.fetch(request)
          if let dbModel = models.first {
            context.delete(dbModel)
            try context.save()
          } else {
            throw DatabaseProviderError.deleteFailure(message: "No matching NSManagedObject found")
          }
        }
      },
      update: { model in
        try await persistentContainer.performBackgroundTask { context in
          let request = Record.fetchRequest(id: model.id)
          let models = try context.fetch(request)
          if let dbModel = models.first {
            let keys = dbModel.entity.attributesByName.keys
            let mirror = Mirror(reflecting: model)
            for dbEntityKey in keys {
              for property in mirror.children.enumerated() where property.element.label == dbEntityKey {
                let value = property.element.value as AnyObject
                if !value.isKind(of: NSNull.self) {
                  if let casted = value as? (any Transformable) {
                    let transformed = casted.transform()
                    dbModel.setValue(transformed, forKey: dbEntityKey)
                  } else {
                    dbModel.setValue(value, forKey: dbEntityKey)
                  }
                }
              }
            }
            try context.save()
          } else {
            throw DatabaseProviderError.updateFailure(message: "No matching NSManagedObject found")
          }
        }
      },
      fetchAllByValue: { _ in
        fatalError("Must implement in an extension using a concrete Value")
      },
      fetchForValue: { _ in
        fatalError("Must implement in an extension using a concrete Value")
      }
    )
  }
}
