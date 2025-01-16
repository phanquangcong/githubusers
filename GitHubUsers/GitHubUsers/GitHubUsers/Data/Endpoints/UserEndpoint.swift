//
//  UserEndpoint.swift
//  GitHubUsers
//
//

import Networking

import Foundation

public enum UserEndpoint {

  /// Returns the `APIEndpoint` for the GitHub users' list API request.
  /// - Parameters:
  ///   - perPage: The number of users per page.
  ///   - since: The ID of the user to start from (pagination).
  /// - Returns: The configured `APIEndpoint` for the GitHub users list API.
  static func getListUser(perPage: Int = 20, since: Int = 100) -> APIEndpoint {
    return APIEndpoint(
      path: "/users",
      httpMethod: .get,
      urlQueries: [
        "per_page": "\(perPage)",
        "since": "\(since)"
      ]
    )
  }

  /// Returns the `APIEndpoint` for the GitHub user's details API request.
  /// - Parameter loginUsername: The GitHub username to fetch details for.
  /// - Returns: The configured `APIEndpoint` for the GitHub user's details.
  static func getUserDetail(loginUsername: String) -> APIEndpoint {
    return APIEndpoint(
      path: "/users/\(loginUsername)",
      httpMethod: .get
    )
  }
}
