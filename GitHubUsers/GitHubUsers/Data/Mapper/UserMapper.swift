//
//  UserMapper.swift
//  GitHubUsers
//
//


import Foundation
import Networking

struct UserMapper: Mappable {
  typealias Input = [User]
  typealias Output = [UserEntity]
    
  func map(_ input: [User]) throws -> [UserEntity] {
    input.map {
      return UserEntity(
        id: UUID(),
        login: $0.login ?? "",
        avatarUrl: $0.avatarUrl ?? "",
        htmlUrl: $0.htmlUrl ?? ""
      )
    }
  }
}
