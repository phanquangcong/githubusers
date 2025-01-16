//
//  NetworkingClient.swift
//
//
//  Created by Dylan Phan on 4/9/24.
//

import Foundation
import Logger

/// Enum to represent the various error types that may occur during API requests.
public enum APIError: Error, Equatable {

  /// Error when the endpoint is invalid.
  case invalidEndpoint

  /// Error when the server responds with a bad status code (i.e., non-2xx range).
  case badServerResponse

  /// Error when there is no network connectivity.
  case networkError

  /// Error that occurs during parsing of data.
  case parsing(Error)

  /// Error related to an invalid access token (e.g., expired or malformed).
  case invalidAccessToken

  /// Error related to an invalid refresh token (e.g., expired or malformed).
  case invalidRefreshToken

  // Custom comparison for equality between `APIError` cases.
  public static func == (lhs: APIError, rhs: APIError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidEndpoint, .invalidEndpoint),
      (.badServerResponse, .badServerResponse),
      (.invalidAccessToken, .invalidAccessToken),
      (.invalidRefreshToken, .invalidRefreshToken),
      (.networkError, .networkError):
      return true
    case (.parsing(let lhsError), .parsing(let rhsError)):
      return (lhsError as NSError).isEqual(rhsError as NSError)
    default:
      return false
    }
  }
}

extension APIError {
  /// A human-readable message for each error.
  public var message: String {
    switch self {
    case .networkError:
      return "Rất tiếc! Hiện tại không thể kết nối tới hệ thống. Hãy kiểm tra lại kết nối internet."
    case .badServerResponse:
      return "Xin lỗi, chúng tôi gặp vấn đề với hệ thống. Vui lòng thử lại sau."
    default:
      return "Lỗi không xác định"
    }
  }
}

/// Typealias for the API response, containing the raw data and status code.
public typealias APIResponse = (data: Data, statusCode: Int)

/// Protocol for the network client service, defining methods to perform API requests.
public protocol NetworkClientService {

  /// Perform an API request and return the raw response.
  /// - Parameter endpoint: The endpoint to make the request to.
  /// - Returns: A `Result` with the API response data or an error.
  func request(_ endpoint: EndPointType) async -> Result<APIResponse, APIError>

  /// Perform an API request and decode the response data into a specific model.
  /// - Parameters:
  ///   - endpoint: The endpoint to make the request to.
  ///   - type: The type of the model to decode the response into.
  ///   - decoder: The JSON decoder to use for decoding.
  /// - Throws: An error if the decoding fails or the request fails.
  /// - Returns: The decoded model of type `T`.
  func request<T: Decodable>(_ endpoint: EndPointType, as type: T.Type, using decoder: JSONDecoder) async throws -> T

  /// Perform an API request and map the response data into a specific model using a mapper.
  /// - Parameters:
  ///   - endpoint: The endpoint to make the request to.
  ///   - mapper: The object that maps the response data into the desired model.
  /// - Throws: An error if the request or mapping fails.
  /// - Returns: The mapped model of type `T`.
  func request<T, M: Mappable>(_ endpoint: EndPointType, using mapper: M) async throws -> T where M.Output == T
}

public extension NetworkClientService {

  /// Perform an API request and decode the response data into a specific model using the default `JSONDecoder`.
  /// - Parameters:
  ///   - endpoint: The endpoint to make the request to.
  ///   - type: The type of the model to decode the response into.
  /// - Throws: An error if the decoding fails or the request fails.
  /// - Returns: The decoded model of type `T`.
  func request<T: Decodable>(_ endpoint: EndPointType, as type: T.Type) async throws -> T {
    try await request(endpoint, as: type, using: JSONDecoder())
  }
}

/// Implementation of the `NetworkClientService` protocol that handles making API requests.
public final class NetworkClientServiceImpl: NetworkClientService {

  /// Configuration for the network client (e.g., base URL and headers).
  public struct Configuration {
    let baseURL: URL?
    let baseHeaders: [String: String]

    /// Default configuration with no base URL and no headers.
    public init(baseURL: URL?, baseHeaders: [String: String]) {
      self.baseURL = baseURL
      self.baseHeaders = baseHeaders
    }

    /// The default configuration.
    public static let `default` = Configuration(baseURL: nil, baseHeaders: [:])
  }

  private let logger: Logger
  private let configuration: Configuration

  /// Initializes a new `NetworkClientServiceImpl` with the provided logger and configuration.
  /// - Parameters:
  ///   - logger: A logger instance to log network requests and responses.
  ///   - configuration: The network client configuration (default used if not specified).
  public init(logger: Logger, configuration: Configuration = .default) {
    self.logger = logger
    self.configuration = configuration
  }

  /// Builds the URLRequest from the provided endpoint.
  /// - Parameter endpoint: The API endpoint to build the request for.
  /// - Returns: A `URLRequest` object representing the request to be made.
  private func buildURLRequest(from endpoint: EndPointType) -> URLRequest? {
    guard let baseURL = configuration.baseURL else {
      return nil
    }

    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) ?? URLComponents()
    components.path = endpoint.path
    components.queryItems = endpoint.urlQueries?.map { URLQueryItem(name: $0.key, value: $0.value) }

    guard let url = components.url else { return nil }

    var request = URLRequest(url: url)
    request.httpMethod = endpoint.httpMethod.rawValue
    request.allHTTPHeaderFields = configuration.baseHeaders.merging(endpoint.headers ?? [:]) { (_, new) in new }

    switch endpoint.bodyParameter {
    case .data(let data):
      request.httpBody = data
    case .dictionary(let dict, let options):
      request.httpBody = try? JSONSerialization.data(withJSONObject: dict, options: options)
    case .encodable(let object, let encoder):
      request.httpBody = try? encoder.encode(object)
    default:
      break
    }

    return request
  }

  /// Performs an API request and returns the response data or an error.
  /// - Parameter endpoint: The API endpoint to request.
  /// - Returns: A `Result` containing the response data or an API error.
  public func request(_ endpoint: EndPointType) async -> Result<APIResponse, APIError> {
    guard NetworkReachability.shared.isConnected else {
      return .failure(.networkError)
    }

    guard let request = buildURLRequest(from: endpoint) else {
      return .failure(.invalidEndpoint)
    }

    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      let httpResponse = response as? HTTPURLResponse
      logger.log(request: request, data: data, response: httpResponse, error: nil)

      guard let httpResponse = httpResponse, (200..<400).contains(httpResponse.statusCode) else {
        if httpResponse?.statusCode == 401 {
          return .failure(.invalidAccessToken)
        }
        if httpResponse?.statusCode == 403 {
          return .failure(.invalidRefreshToken)
        }
        return .failure(.badServerResponse)
      }
      return .success((data, httpResponse.statusCode))
    } catch {
      logger.log(request: request, data: nil, response: nil, error: error)
      return .failure(.badServerResponse)
    }
  }

  /// Performs an API request and decodes the response data into a specified model.
  /// - Parameters:
  ///   - endpoint: The API endpoint to request.
  ///   - type: The type of model to decode the response into.
  ///   - decoder: The JSON decoder to use for decoding (defaults to `JSONDecoder()`).
  /// - Throws: Throws an error if the request or decoding fails.
  /// - Returns: The decoded model of type `T`.
  public func request<T: Decodable>(
    _ endpoint: EndPointType,
    as type: T.Type,
    using decoder: JSONDecoder = JSONDecoder()
  ) async throws -> T {
    let result = await request(endpoint)
    switch result {
    case .success(let (data, _)):
      do {
        return try decoder.decode(T.self, from: data)
      } catch {
        logger.log(level: .error, message: "❌ error: \(error)")
        throw error
      }
    case .failure(let error):
      throw error
    }
  }

  /// Performs an API request and maps the response data using the provided mapper.
  /// - Parameters:
  ///   - endpoint: The API endpoint to request.
  ///   - mapper: The mapper to transform the response data into a model.
  /// - Throws: Throws an error if the request or mapping fails.
  /// - Returns: The mapped model of type `T`.
  public func request<T, M: Mappable>(_ endpoint: EndPointType, using mapper: M) async throws -> T where M.Output == T {
    let responseModel: M.Input = try await request(endpoint, as: M.Input.self)
    return try mapper.map(responseModel)
  }
}
