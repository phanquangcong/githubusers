//
//  Mappable.swift
//
//
//  Created by Dylan Phan on 4/9/24.
//

import Foundation

/// A protocol that defines the mapping functionality between a source object and a target object.
///
/// Conforming types are expected to define a method to transform an object of type `Input` (which conforms to `Decodable`)
/// into an object of type `Output`. This is useful when you need to transform data received from an API into
/// a model used in your application.
///
/// - `Input`: The type of the input data (conforming to `Decodable`).
/// - `Output`: The type of the output data after transformation.
public protocol Mappable {
  
  /// The type of the input data that will be transformed.
  associatedtype Input: Decodable
  
  /// The type of the output data after transformation.
  associatedtype Output
  
  /// Maps the input data to the output data.
  ///
  /// - Parameter input: The input data of type `Input`, which is typically received from an external source
  ///                    such as a network response.
  /// - Throws: This method can throw errors if the transformation fails, such as if the input data is invalid
  ///           or does not match the expected format.
  /// - Returns: An instance of the `Output` type, which is the transformed data ready for use in your application.
  ///
  /// - Example:
  /// ```
  /// let responseData: APIResponse = ... // Data fetched from API
  /// let model: MyModel = try mapper.map(responseData)
  /// ```
  func map(_ input: Input) throws -> Output
}
