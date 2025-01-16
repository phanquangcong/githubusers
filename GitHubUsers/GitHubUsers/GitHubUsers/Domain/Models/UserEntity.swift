//
//  UserEntity.swift
//  GitHubUsers
//
//


import Foundation

struct UserEntity: Identifiable, Equatable {
  let id: UUID
  let login: String
  let avatarUrl: String
  let htmlUrl: String

  static func ==(lhs: UserEntity, rhs: UserEntity) -> Bool {
    return lhs.login == rhs.login
  }
}
