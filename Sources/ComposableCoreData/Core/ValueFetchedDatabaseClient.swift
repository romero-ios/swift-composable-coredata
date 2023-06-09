//
//  ValueFetchedDatabaseClient.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

/// `ValueFetchedDatabaseProviding` is a protocol that extends `DatabaseProviding` to add additional fetch methods
/// that allow retrieval of records by a specific hashable value. This is typically useful for fetch operations
/// where you need to retrieve records based on specific criteria or conditions, such as retrieving all records
/// with a certain property value.
///
/// Conforming to the `ValueFetchedDatabaseProviding` protocol requires specifying one associated type:
///
/// - `HashableType`: The type of the value that will be used to fetch records. It should conform to the `Hashable` protocol.
///
/// The `ValueFetchedDatabaseProviding` protocol requires implementing two properties:
///
/// - `fetchAllByValue`: An asynchronous function which, when called with an instance of `HashableType`, fetches
///   all `Model` instances from the database that match the provided value and returns them as an array.
///   It throws an error if the fetch operation fails.
///
/// - `fetchForValue`: An asynchronous function which, when called with an instance of `HashableType`, fetches
///   the first `Model` instance from the database that matches the provided value.
///   It throws an error if the fetch operation fails.
public protocol ValueFetchedDatabaseProviding: DatabaseProviding {
    associatedtype HashableType: Hashable

    var fetchAllByValue: (HashableType) async throws -> [Record.Model] { get set }
    var fetchForValue: (HashableType) async throws -> Record.Model { get set }
}
