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

    func test_GIVEN_term_WHEN_use_case_is_invoked_THEN_it_should_return_no_error() {
        recentSearchGateway.insertTermQueue.set(nil)

        let invokeExpectation = expectation(description: "invoke expectation")
        var error: RecentSearchError?

        saveSearchTermUseCase.invoke(term: "Rio") { errorResult in
            error = errorResult
            invokeExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(recentSearchGateway.term, "Rio")
        XCTAssertNil(error)

    }

    func test_GIVEN_term_WHEN_use_case_is_invoked_and_gateway_fails_THEN_it_should_return_insert_error() {
        recentSearchGateway.insertTermQueue.set(.unableToInsert)

        let invokeExpectation = expectation(description: "invoke expectation")
        var error: RecentSearchError?

        saveSearchTermUseCase.invoke(term: "Rio") { errorResult in
            error = errorResult
            invokeExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(recentSearchGateway.term, "Rio")
        XCTAssertEqual(error, .unableToInsert)
    }
}
