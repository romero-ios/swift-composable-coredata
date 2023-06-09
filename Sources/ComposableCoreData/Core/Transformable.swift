//
//  File.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

/// This protocol is designed to provide transformation capabilities for models with properties of the `Transformable` type, which require the use of `NSSecureCoding`.
///
/// Types adopting `Transformable` need to specify an associated type `Model` conforming to `NSSecureCoding`, and must implement a method `transform() -> Model`.
///
/// - Associatedtype: `Model`
///   The type of object that will be produced after transformation. This type must conform to `NSSecureCoding` to ensure the transformed object is secure and ready for storage or transmission.
///
/// - Method: `transform() -> Model`
///   This method is used to convert the current instance into an instance of `Model`. This method must be implemented by any conforming type.
public protocol Transformable {
  associatedtype Model: NSSecureCoding
  
  func transform() -> Model
}
