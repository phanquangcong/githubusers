//
//  UserDetailMapper.swift
//  GitHubUsers
//
//


import Foundation
import Networking

struct UserDetailMapper: Mappable {
  typealias Input = UserDetail
  typealias Output = UserDetailEntity
    
  func map(_ input: UserDetail) throws -> UserDetailEntity {
    return UserDetailEntity(
      login: input.login ?? "",
      avatarUrl: input.avatarUrl ?? "",
      htmlUrl: input.htmlUrl ?? "",
      location: input.location ?? "",
      followers: input.followers ?? 0,
      following: input.following ?? 0
    )
  }
}
