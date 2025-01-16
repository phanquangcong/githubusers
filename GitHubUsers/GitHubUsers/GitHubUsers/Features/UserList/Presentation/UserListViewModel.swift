//
//  UserListViewModel.swift
//  GitHubUsers
//
//

import SwiftUI

@MainActor
final class UserListViewModel: ObservableObject {
  @Published var users: [UserEntity] = []
  @Published var isLoading: Bool = false
  @Published var error: Error? = nil
  
  private var currentPage = 0
  private let pageSize = 20
  private let userRepository: UserUseCase
  
  init(userRepository: UserUseCase) {
    self.userRepository = userRepository
  }
  
  func loadUsers() async {
    guard !isLoading else { return }
    
    isLoading = true
    let since = currentPage * pageSize
    
    do {
      let newUsers = try await userRepository.getListUser(perPage: pageSize, since: since)
      users.append(contentsOf: newUsers)
      
      currentPage += 1
      
      isLoading = false
    } catch {
      isLoading = false
      self.error = error
    }
  }
  
  func loadMoreIfNeeded(for user: UserEntity) {
      guard !isLoading else { return }
      guard let lastUser = users.last, user == lastUser else { return }

      Task {
          await loadUsers()
      }
  }
}
