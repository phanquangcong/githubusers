//
//  UserRepository.swift
//  GitHubUsers
//
//

import Foundation
import Networking

final class UserRepository: UserUseCase {
  private let networkClientService: NetworkClientService
  private let userMapper: UserMapper
  private let userDetailMapper: UserDetailMapper

  init(networkClientService: NetworkClientService, userMapper: UserMapper = .init(), userDetailMapper: UserDetailMapper = .init()) {
    self.networkClientService = networkClientService
    self.userMapper = userMapper
    self.userDetailMapper = userDetailMapper
  }

  func getListUser(perPage: Int, since: Int) async throws -> [UserEntity] {
    try await networkClientService.request(UserEndpoint.getListUser(), using: userMapper)
  }

  func getUser(with loginUsername: String) async throws -> UserDetailEntity {
    try await networkClientService.request(UserEndpoint.getUserDetail(loginUsername: loginUsername), using: userDetailMapper)
  }
}
