//
//  AppConfig.swift
//  GitHubUsers
//
//

import Networking
import Logger
import Foundation

struct AppConfig {
  let networkClient: NetworkClientService
  let logger: Logger = {
#if DEBUG
    return LoggerImpl(label: "GitHubUsers_UAT")
#else
    return LoggerImpl(label: "GitHubUsers_PROD")
#endif
  }()

  init() {
    networkClient = NetworkClientServiceImpl(
      logger: logger,
      configuration: .init(
        baseURL: Environment.baseURL,
        baseHeaders: [
          "Content-Type": "application/json;charset=utf-8"
        ]
      )
    )
  }
}
