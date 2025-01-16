//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//

import SwiftUI
import Networking
import Logger

@main
struct GitHubUsersApp: App {
  let appConfig = AppConfig()
  let userListViewModel: UserListViewModel
  @StateObject var router = Router()
  
  init() {
    let userRepository = UserRepository(networkClientService: appConfig.networkClient)
    userListViewModel = UserListViewModel(userRepository: userRepository)
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.navPath) {
        UserListCoordinator(dependencies: .init(apiClient: appConfig.networkClient))
      }
      .environmentObject(router)
    }
  }
}
