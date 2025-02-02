//
// Updated on 01/16/25.///
/// @Generated by Mockolo
///

@testable import GitHubUsers

class UserUseCaseMock: UserUseCase {
    init() { }

    private(set) var getListUserCallCount = 0
    var getListUserHandler: ((Int, Int) async throws -> ([UserEntity]))?
    func getListUser(perPage: Int, since: Int) async throws -> [UserEntity] {
        getListUserCallCount += 1
        if let getListUserHandler = getListUserHandler {
            return try await getListUserHandler(perPage, since)
        }
        return [UserEntity]()
    }

    private(set) var getUserCallCount = 0
    var getUserHandler: ((String) async throws -> (UserDetailEntity))?
    func getUser(with loginUsername: String) async throws -> UserDetailEntity {
        getUserCallCount += 1
        if let getUserHandler = getUserHandler {
            return try await getUserHandler(loginUsername)
        }
        fatalError("getUserHandler returns can't have a default value thus its handler must be set")
    }
}
