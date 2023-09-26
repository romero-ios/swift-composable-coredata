//
//  DatabaseClient+Live.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import OSLog
import CoreData
import Foundation

public struct DatabaseClient<Model: CoreDataConvertible, Record: ModelConvertible>: DatabaseProviding where Record.Model == Model {
  private var _fetch: () async throws -> [Record.Model]
  private var _create: (Model) async throws -> Void
  private var _delete: (Model) async throws -> Void
  private var _update: (Model) async throws -> Void

  public var fetch: () async throws -> [Record.Model] {
    get {
      return _fetch
    }
    set {
      _fetch = newValue
      // Log when the fetch property is set
      os_log("fetch property set")
    }
  }

  public var create: (Model) async throws -> Void {
    get {
      return _create
    }
    set {
      _create = newValue
      // Log when the create property is set
      os_log("create property set")
    }
  }

  public var delete: (Model) async throws -> Void {
    get {
      return _delete
    }
    set {
      _delete = newValue
      // Log when the delete property is set
      os_log("delete property set")
    }
  }

  public var update: (Model) async throws -> Void {
    get {
      return _update
    }
    set {
      _update = newValue
      // Log when the update property is set
      os_log("update property set")
    }
  }

  public init(
    fetch: @escaping () async throws -> [Record.Model],
    create: @escaping (Model) async throws -> Void,
    delete: @escaping (Model) async throws -> Void,
    update: @escaping (Model) async throws -> Void
  )
  {
    self._fetch = fetch
    self._create = create
    self._delete = delete
    self._update = update

    os_log(
      "%@ initialized with fetch: %@, create: %@, delete: %@, update: %@",
      String(describing: type(of: Self.self)),
      String(describing: fetch),
      String(describing: create),
      String(describing: delete),
      String(describing: update)
    )
  }
}


extension DatabaseClient where Model.ID == Record.ID {
  /// The `DatabaseClient` extension provides a convenience static function `live` for creating a `DatabaseClient` instance
  /// with the provided `NSPersistentContainer`.
  ///
  /// The `live` function sets up the `fetch`, `create`, `delete`, and `update` operations to use the `NSPersistentContainer`'s
  /// background context for performing these operations.
  ///
  /// This extension assumes that the `ID` of the `Model` type matches the `ID` of the `Record` type.
  public static func live(persistentContainer: NSPersistentContainer) -> Self {
    return .init(
      fetch: {
        let context = persistentContainer.newBackgroundContext()
        return try await withCheckedThrowingContinuation { continuation in
          context.perform {
            let request = Record.fetchRequest()
            do {
              let models = try context.fetch(request)
                .map { ($0 as! Record).convert() }
              continuation.resume(returning: models)
            } catch {
              continuation.resume(throwing: DatabaseProviderError.fetchFailure(message: "Unable to fetch \(String(describing: type(of: Record.self)))"))
            }
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
                  dbModel.setValue(value, forKey: dbEntityKey)
                }
              }
            }
            try context.save()
          } else {
            throw DatabaseProviderError.updateFailure(message: "No matching NSManagedObject found")
          }
          
        }
      }
      
    )
  }
}
