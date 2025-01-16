//
//  EndPoint.swift
//
//
//  Created by Dylan Phan on 4/9/24.
//

import Foundation

/// An enumeration of HTTP methods used for making network requests.
/// Each case corresponds to an HTTP method with the associated string value used in the request.
public enum HTTPMethod: String {
  
  /// Represents a GET request, used to retrieve data from the server.
  case get = "GET"
  
  /// Represents a POST request, used to send data to the server.
  case post = "POST"
  
  /// Represents a PUT request, typically used to update data on the server.
  case put = "PUT"
  
  /// Represents a PATCH request, used to make partial updates to data on the server.
  case patch = "PATCH"
  
  /// Represents a DELETE request, used to delete data on the server.
  case delete = "DELETE"
}

/// An enumeration that represents different types of body parameters that can be passed in a network request.
///
/// - `data`: Used when the body contains raw `Data`.
/// - `dictionary`: Used when the body contains a dictionary that needs to be serialized into JSON.
/// - `encodable`: Used when the body contains an object that conforms to `Encodable` and needs to be encoded into JSON.
public enum BodyParameter {
  
  /// A `Data` object, representing raw binary data.
  case data(Data)
  
  /// A dictionary of key-value pairs, which will be serialized into JSON.
  /// - Parameters:
  ///   - options: Options to control the JSONSerialization behavior, defaulting to an empty array.
  case dictionary([String: Any], options: JSONSerialization.WritingOptions = [])
  
  /// An `Encodable` object, which will be encoded into JSON using a `JSONEncoder`.
  /// - Parameters:
  ///   - encoder: The encoder to use for serializing the `Encodable` object, defaulting to `JSONEncoder()`.
  case encodable(Encodable, encoder: JSONEncoder = .init())
}

/// A protocol that defines the necessary properties and methods required to construct an API endpoint.
/// Conforming types should use this to represent a single endpoint in a RESTful API, including the URL, HTTP method, headers, and body.
///
/// This is a contract for any API endpoint in your application, enabling flexible and reusable networking code.
public protocol EndPointType {
  
  /// The base URL for the endpoint (e.g., `https://api.example.com`).
  /// - Note: This can be `nil` if a full URL is provided in the `path`.
  var baseURL: URL? { get }
  
  /// The specific path of the API endpoint (e.g., `/users`).
  var path: String { get }
  
  /// The HTTP method to be used for the request (e.g., `.get`, `.post`).
  var httpMethod: HTTPMethod { get }
  
  /// The URL query parameters to be appended to the URL.
  /// - Note: This is optional and will be appended to the URL if provided.
  var urlQueries: [String: String]? { get }
  
  /// The headers to be included in the request.
  /// - Note: This is optional and can be `nil` if no headers are required.
  var headers: [String: String]? { get }
  
  /// The body parameter for the request, if any.
  /// - Note: This is optional and can be used for `POST`, `PUT`, or `PATCH` requests that require a body.
  var bodyParameter: BodyParameter? { get }
}

/// A struct that represents a specific API endpoint. It conforms to the `EndPointType` protocol, providing all the necessary
/// information to construct an API request (e.g., base URL, path, HTTP method, headers, query parameters, and body parameters).
///
/// This struct is used to encapsulate the details of an API endpoint, making it easy to construct requests and interact with APIs.
public struct APIEndpoint: EndPointType {
  
  /// The base URL for the API, typically something like `https://api.example.com`.
  public let baseURL: URL?
  
  /// The specific path to the resource or endpoint (e.g., `/users`).
  public let path: String
  
  /// The HTTP method for the request (e.g., `.get`, `.post`).
  public let httpMethod: HTTPMethod
  
  /// Optional query parameters to be appended to the URL (e.g., `?page=1`).
  public let urlQueries: [String: String]?
  
  /// Optional headers to be included in the request (e.g., `Content-Type: application/json`).
  public let headers: [String: String]?
  
  /// Optional body parameters for requests that require a request body (e.g., `POST`, `PUT`).
  public let bodyParameter: BodyParameter?
  
  /// Initializes an `APIEndpoint` with the specified values for base URL, path, HTTP method, query parameters, headers, and body.
  ///
  /// - Parameters:
  ///   - baseURL: The base URL for the API (e.g., `https://api.example.com`).
  ///   - path: The path of the endpoint (e.g., `/users`).
  ///   - httpMethod: The HTTP method to use (e.g., `.get`, `.post`).
  ///   - urlQueries: Optional query parameters to append to the URL (e.g., `?page=1`).
  ///   - headers: Optional headers to include in the request (e.g., `Content-Type`).
  ///   - bodyParameter: Optional body parameter to include in the request.
  public init(
    baseURL: URL? = nil,
    path: String,
    httpMethod: HTTPMethod,
    urlQueries: [String: String]? = nil,
    headers: [String: String]? = nil,
    bodyParameter: BodyParameter? = nil
  ) {
    self.baseURL = baseURL
    self.path = path
    self.httpMethod = httpMethod
    self.urlQueries = urlQueries
    self.headers = headers
    self.bodyParameter = bodyParameter
  }
}
