import XCTest
@testable import WeatherApp

final class GetRecentSearchTermsUseCaseTests: XCTestCase {
    private var recentSearchGateway: MockRecentSearchGateway!
    private var getRecentSearchTermsUseCase: GetRecentSearchTermsUseCaseImplementation!

    override func setUp() {
        super.setUp()
        recentSearchGateway = MockRecentSearchGateway()
        getRecentSearchTermsUseCase = GetRecentSearchTermsUseCaseImplementation(recentSearchGateway: recentSearchGateway)
    }

    override func tearDown() {
        super.tearDown()
        getRecentSearchTermsUseCase = nil
        recentSearchGateway = nil
    }

    func test_WHEN_use_case_is_invoked_THEN_it_should_return_recent_terms() {
        let expectedTerms = ["Rio", "Lisbon"]

        recentSearchGateway.fetchAllTermsQueue.set(.success(expectedTerms))

        let invokeExpectation = expectation(description: "invoke expectation")
        var actualTerms: [String]?

        getRecentSearchTermsUseCase.invoke{ result in
            actualTerms = try? result.get()
            invokeExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(actualTerms, expectedTerms)

    }


    func test_WHEN_use_case_is_invoked_and_gateway_fails_THEN_it_should_return_fetch_error() {
        recentSearchGateway.fetchAllTermsQueue.set(.failure(.unableToFetch))

        let invokeExpectation = expectation(description: "invoke expectation")
        var error: RecentSearchError?

        getRecentSearchTermsUseCase.invoke { result in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            invokeExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(error, .unableToFetch)
    }
}
