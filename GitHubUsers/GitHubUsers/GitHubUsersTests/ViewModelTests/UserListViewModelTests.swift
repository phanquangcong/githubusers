//
//  UserListViewModelTests.swift
//  GitHubUsers
//
//

import XCTest
@testable import GitHubUsers

class UserListViewModelTests: XCTestCase {
  var mockUserRepository: UserUseCaseMock!
  var viewModel: UserListViewModel!

  override func setUp() async throws {
    mockUserRepository = UserUseCaseMock()
    viewModel = await UserListViewModel(userRepository: mockUserRepository)
  }

  override func tearDown() async throws {
    viewModel = nil
    mockUserRepository = nil
  }

  // MARK: - Test loading users successfully
  func testLoadUsersSuccessfully() async throws {
    // Given: Mock the getListUser handler to return a list of users
    let mockUsers = [UserEntity(id: UUID(), login: "user1", avatarUrl: "", htmlUrl: "")]
    mockUserRepository.getListUserHandler = { (perPage: Int, since: Int) in
      return mockUsers
    }

    // When: Call loadUsers
    await viewModel.loadUsers()

    // Then: Assert that the users array is updated
    await MainActor.run {
      XCTAssertEqual(viewModel.users.count, 1, "Users should be loaded successfully.")
      XCTAssertEqual(viewModel.users.first?.login, "user1", "The first user's login should be 'user1'.")
      XCTAssertNil(viewModel.error, "Error should be nil.")
      XCTAssertFalse(viewModel.isLoading, "Loading flag should be false.")
    }
  }

  // MARK: - Test loading users with error
  func testLoadUsersWithError() async throws {
    // Given: Mock the getListUser handler to throw an error
    mockUserRepository.getListUserHandler = { (perPage: Int, since: Int) in
      throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
    }

    // When: Call loadUsers
    await viewModel.loadUsers()

    // Then: Assert that the error message is set
    await MainActor.run {
      XCTAssertEqual(viewModel.error?.localizedDescription, "Network error", "Error message should match the error description.")
      XCTAssertFalse(viewModel.isLoading, "Loading flag should be false.")
    }
  }

  // MARK: - Test loading more if not needed
  func testLoadMoreIfNeededWhenNotLastUser() async throws {
    // Given: Mock the getListUser handler to return a list of users
    let mockUsers = [UserEntity(id: UUID(), login: "user1", avatarUrl: "", htmlUrl: "")]
    mockUserRepository.getListUserHandler = { (perPage: Int, since: Int) in
      return mockUsers
    }

    // Given: Initially load some users
    await viewModel.loadUsers()

    // When: Call loadMoreIfNeeded with a user that is not the last one
    let middleUser = await viewModel.users.first!
    await viewModel.loadMoreIfNeeded(for: middleUser)

    // Then: Assert that loadMoreIfNeeded doesn't trigger a load
    await MainActor.run {
      XCTAssertEqual(viewModel.users.count, 1, "The user count should not change.")
    }
  }
}
