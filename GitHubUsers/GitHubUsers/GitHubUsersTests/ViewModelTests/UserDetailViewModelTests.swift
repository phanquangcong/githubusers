//
//  UserDetailViewModelTests.swift
//  GitHubUsers
//
//

import XCTest
@testable import GitHubUsers

class UserDetailViewModelTests: XCTestCase {
  
  var viewModel: UserDetailViewModel!
  var mockUserRepository: UserUseCaseMock!
  
  override func setUp() async throws {
    mockUserRepository = UserUseCaseMock()
    viewModel = await UserDetailViewModel(userRepository: mockUserRepository)
  }
  
  override func tearDown() async throws {
    viewModel = nil
    mockUserRepository = nil
  }
  
  // MARK: - Test fetching user detail successfully
  
  func testFetchUserDetailSuccessfully() async throws {
    // Given: Mock the getUser handler to return a user
    let mockUser = UserDetailEntity(login: "user1", avatarUrl: "https://example.com/avatar.png", htmlUrl: "https://github.com/user1", location: "Earth", followers: 100, following: 50)
    mockUserRepository.getUserHandler = { loginUsername in
      XCTAssertEqual(loginUsername, "user1") // Ensure the correct username is passed
      return mockUser // Return mock user
    }
    
    // When: Call fetchUserDetail
    await viewModel.fetchUserDetail(loginUsername: "user1")
    
    // Then: Assert that the userDetail is set correctly
    await MainActor.run {
      XCTAssertEqual(viewModel.userDetail?.login, "user1", "User detail login should be 'user1'")
      XCTAssertEqual(viewModel.userDetail?.avatarUrl, "https://example.com/avatar.png", "Avatar URL should be correct.")
      XCTAssertEqual(viewModel.userDetail?.htmlUrl, "https://github.com/user1", "HTML URL should be correct.")
      XCTAssertEqual(viewModel.userDetail?.location, "Earth", "Location should be correct.")
      XCTAssertEqual(viewModel.userDetail?.followers, 100, "Followers count should be correct.")
      XCTAssertEqual(viewModel.userDetail?.following, 50, "Following count should be correct.")
      XCTAssertNil(viewModel.errorMessage, "Error message should be nil.")
      XCTAssertFalse(viewModel.isLoading, "Loading flag should be false.")
    }
  }
  
  // MARK: - Test fetching user detail with error
  
  func testFetchUserDetailWithError() async throws {
    // Given: Mock the getUser handler to throw an error
    mockUserRepository.getUserHandler = { loginUsername in
      throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
    }
    
    // When: Call fetchUserDetail
    await viewModel.fetchUserDetail(loginUsername: "user1")
    
    // Then: Assert that the error message is set
    await MainActor.run {
      XCTAssertNil(viewModel.userDetail, "User detail should be nil.")
      XCTAssertEqual(viewModel.errorMessage, "Error fetching user detail: User not found", "Error message should match the expected error description.")
      XCTAssertFalse(viewModel.isLoading, "Loading flag should be false.")
    }
  }
  
  // MARK: - Test loading state
  
  func testLoadingState() async throws {
    // Given: Mock the getUser handler with a delay to simulate loading
    mockUserRepository.getUserHandler = { loginUsername in
      try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay
      return UserDetailEntity(login: "user1", avatarUrl: "https://example.com/avatar.png", htmlUrl: "https://github.com/user1", location: "Earth", followers: 100, following: 50)
    }
    
    // When: Start the fetchUserDetail asynchronously
    let fetchTask = Task {
      await viewModel.fetchUserDetail(loginUsername: "user1")
    }
    
    // Allow the task to complete
    await fetchTask.value
    
    // Assert loading flag is false after completion
    await MainActor.run {
      XCTAssertFalse(viewModel.isLoading, "Loading flag should be false after fetch completion.")
    }
  }
  
}
