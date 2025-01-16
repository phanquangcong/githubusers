//
//  UserDetailViewModel.swift
//  GitHubUsers
//
//

import Foundation

@MainActor
final class UserDetailViewModel: ObservableObject {
  private let userRepository: UserUseCase
  @Published var userDetail: UserDetailEntity?
  @Published var isLoading: Bool = false
  @Published var errorMessage: String? = nil
  
  init(userRepository: UserUseCase) {
    self.userRepository = userRepository
  }
  
  func fetchUserDetail(loginUsername: String) async {
    isLoading = true
    do {
      let userDetailEntity = try await userRepository.getUser(with: loginUsername)
      self.userDetail = userDetailEntity
      isLoading = false
    } catch {
      isLoading = false
      self.errorMessage = "Error fetching user detail: \(error.localizedDescription)"
    }
  }
}
