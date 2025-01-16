//
//  UserDetail.swift
//  GitHubUsers
//
//


import Foundation

public struct UserDetail: Decodable {
  public let login: String?
  public let avatarUrl: String?
  public let htmlUrl: String?
  public let location: String?
  public let followers: Int?
  public let following: Int?
  
  enum CodingKeys: String, CodingKey {
    case login
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
    case location
    case followers
    case following
  }
}
