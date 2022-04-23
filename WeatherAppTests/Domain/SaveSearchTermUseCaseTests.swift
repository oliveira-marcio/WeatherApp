import XCTest
@testable import WeatherApp

final class SaveSearchTermUseCaseTests: XCTestCase {
    private var recentSearchGateway: MockRecentSearchGateway!
    private var saveSearchTermUseCase: SaveSearchTermUseCaseImplementation!

    override func setUp() {
        super.setUp()
        recentSearchGateway = MockRecentSearchGateway()
        saveSearchTermUseCase = SaveSearchTermUseCaseImplementation(recentSearchGateway: recentSearchGateway)
    }

    override func tearDown() {
        super.tearDown()
        saveSearchTermUseCase = nil
        recentSearchGateway = nil
    }

    func test_GIVEN_term_WHEN_use_case_is_invoked_THEN_it_should_return_no_error() async throws {
        recentSearchGateway.insertTermQueue.set(nil)

        try await saveSearchTermUseCase.invoke(term: "Rio")

        XCTAssertEqual(recentSearchGateway.term, "Rio")
    }

    func test_GIVEN_term_WHEN_use_case_is_invoked_and_gateway_fails_THEN_it_should_return_insert_error() async {
        recentSearchGateway.insertTermQueue.set(.unableToInsert)

        var errorResult: RecentSearchError?

        do {
            try await saveSearchTermUseCase.invoke(term: "Rio")
        } catch {
            errorResult = error as? RecentSearchError
        }

        XCTAssertEqual(recentSearchGateway.term, "Rio")
        XCTAssertEqual(errorResult, .unableToInsert)
    }
}
