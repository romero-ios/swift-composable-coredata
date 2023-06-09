//
//  File.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

/// This enum defines a set of errors that can occur while interacting with the database. Each case includes a `message` to provide context about the failure.
///
/// - Case: `fetchFailure(message: String)`
///   This error case represents a failure while attempting to fetch data from the database. The associated `message` should provide specifics about the fetch error.
///
/// - Case: `deleteFailure(message: String)`
///   This error case represents a failure while attempting to delete data from the database. The associated `message` should provide specifics about the delete error.
///
/// - Case: `updateFailure(message: String)`
///   This error case represents a failure while attempting to update data in the database. The associated `message` should provide specifics about the update error.
public enum DatabaseProviderError: Error {
  case fetchFailure(message: String)
  case deleteFailure(message: String)
  case updateFailure(message: String)
}
