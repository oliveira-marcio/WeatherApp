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

    func test_WHEN_use_case_is_invoked_THEN_it_should_return_recent_terms() async {
        let expectedTerms = ["Rio", "Lisbon"]

        recentSearchGateway.fetchAllTermsQueue.set(.success(expectedTerms))

        let actualTerms = try? await getRecentSearchTermsUseCase.invoke()

        XCTAssertEqual(actualTerms, expectedTerms)
    }


    func test_WHEN_use_case_is_invoked_and_gateway_fails_THEN_it_should_return_fetch_error() async {
        recentSearchGateway.fetchAllTermsQueue.set(.failure(.unableToFetch))

        var errorResult: RecentSearchError?

        do {
            _ = try await getRecentSearchTermsUseCase.invoke()
        } catch {
            errorResult = error as? RecentSearchError
        }

        XCTAssertEqual(errorResult, .unableToFetch)
    }
}
