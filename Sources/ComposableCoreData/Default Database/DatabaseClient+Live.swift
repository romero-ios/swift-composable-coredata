//
//  DatabaseClient+Live.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import CoreData
import Foundation

extension DatabaseClient where Model.ID == Record.ID {
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
          if let dbModel = models.first as? NSManagedObject {
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
            let managedObject = dbModel as? NSManagedObject
            let keys = managedObject?.entity.attributesByName.keys
            
            let mirror = Mirror(reflecting: model)
            for dbEntityKey in keys! {
              for property in mirror.children.enumerated() where property.element.label == dbEntityKey {
                let value = property.element.value as AnyObject
                if !value.isKind(of: NSNull.self) {
                  managedObject?.setValue(value, forKey: dbEntityKey)
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
