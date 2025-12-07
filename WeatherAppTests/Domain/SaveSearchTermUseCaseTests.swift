import Testing
@testable import WeatherApp

@Suite
struct SaveSearchTermUseCaseTests {
    private let recentSearchGateway: MockRecentSearchGateway
    private let saveSearchTermUseCase: SaveSearchTermUseCaseImplementation

    init() {
        recentSearchGateway = MockRecentSearchGateway()
        saveSearchTermUseCase = SaveSearchTermUseCaseImplementation(recentSearchGateway: recentSearchGateway)
    }

    @Test
    func GIVEN_term_WHEN_use_case_is_invoked_THEN_it_should_return_no_error() async throws {
        recentSearchGateway.insertTermQueue.set(nil)

        try await saveSearchTermUseCase.invoke(term: "Rio")

        #expect(recentSearchGateway.term == "Rio")
    }

    @Test
    func GIVEN_term_WHEN_use_case_is_invoked_and_gateway_fails_THEN_it_should_return_insert_error() async {
        recentSearchGateway.insertTermQueue.set(.unableToInsert)

        await #expect(throws: RecentSearchError.unableToInsert) {
            try await saveSearchTermUseCase.invoke(term: "Rio")
        }
        
        #expect(recentSearchGateway.term == "Rio")
    }
}
