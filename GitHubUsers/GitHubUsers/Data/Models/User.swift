//
//  User.swift
//  GitHubUsers
//
//


import Foundation

struct User: Decodable {
  let login: String?
  let avatarUrl: String?
  let htmlUrl: String?
  
  enum CodingKeys: String, CodingKey {
    case login
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
  }
}
