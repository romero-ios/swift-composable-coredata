//
//  File.swift
//  
//
//  Created by Daniel Romero on 6/8/23.
//

import Foundation

public protocol Transformable {
  associatedtype Model: NSSecureCoding
  
  func transform() -> Model
}
