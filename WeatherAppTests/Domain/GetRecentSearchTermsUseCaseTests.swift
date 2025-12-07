import Testing
@testable import WeatherApp

@Suite
struct GetRecentSearchTermsUseCaseTests {
    private let recentSearchGateway: MockRecentSearchGateway
    private let getRecentSearchTermsUseCase: GetRecentSearchTermsUseCaseImplementation

    init() {
        recentSearchGateway = MockRecentSearchGateway()
        getRecentSearchTermsUseCase = GetRecentSearchTermsUseCaseImplementation(recentSearchGateway: recentSearchGateway)
    }

    @Test
    func WHEN_use_case_is_invoked_THEN_it_should_return_recent_terms() async {
        let expectedTerms = ["Rio", "Lisbon"]

        recentSearchGateway.fetchAllTermsQueue.set(.success(expectedTerms))

        let actualTerms = try? await getRecentSearchTermsUseCase.invoke()

        #expect(actualTerms == expectedTerms)
    }

    @Test
    func WHEN_use_case_is_invoked_and_gateway_fails_THEN_it_should_return_fetch_error() async {
        recentSearchGateway.fetchAllTermsQueue.set(.failure(.unableToFetch))

        await #expect(throws: RecentSearchError.unableToFetch) {
            try await getRecentSearchTermsUseCase.invoke()
        }
    }
}
