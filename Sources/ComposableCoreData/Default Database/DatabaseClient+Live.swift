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
        return try await withCheckedThrowingContinuation { continuation in
          let request = Record.fetchRequest()
          do {
            let models = try persistentContainer.viewContext.fetch(request)
              .map { ($0 as! Record).convert() }
            continuation.resume(returning: models)
          } catch {
              continuation.resume(throwing: DatabaseProviderError.fetchFailure(message: "Unable to fetch \(String(describing: type(of: Record.self)))"))
          }
        }
      },
      create: { model in
        model.convert(in: persistentContainer.viewContext)
        try? persistentContainer.viewContext.save()
      },
      delete: { model in
        let request = Record.fetchRequest(id: model.id)
        do {
          let models = try persistentContainer.viewContext.fetch(request)
          if let dbModel = models.first as? NSManagedObject {
            persistentContainer.viewContext.delete(dbModel)
            try? persistentContainer.viewContext.save()
          }
        } catch {
          fatalError("Woops")
        }
        
      },
      update: { model in
        let request = Record.fetchRequest(id: model.id)
        do {
          let models = try persistentContainer.viewContext.fetch(request)
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
            
            try? persistentContainer.viewContext.save()
          }
        } catch {
          fatalError("Woops")
        }
        
      }
    )
  }
}
