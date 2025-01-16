//
//  UserListCoordinator.swift
//
//

import SwiftUI
import Networking

enum UserDestination: Hashable {
  case userDetail(_ loginUserName: String)
}

struct UserListCoordinator: View {
  @EnvironmentObject private var router: Router
  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  var body: some View {
    UserListView(viewModel: .init(userRepository: UserRepository(networkClientService: dependencies.apiClient)))
      .navigationDestination(for: UserDestination.self) { destination in
        switch destination {
        case .userDetail(let loginUserName):
          UserDetailView(
            loginUsername: loginUserName,
            viewModel: .init(userRepository: UserRepository(
              networkClientService: dependencies.apiClient)
            )
          )
        }
      }
  }
}

extension UserListCoordinator {
  struct Dependencies {
    let apiClient: NetworkClientService
    init(apiClient: NetworkClientService) {
      self.apiClient = apiClient
    }
  }
}
