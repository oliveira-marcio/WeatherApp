@testable import WeatherApp

final class FakeGetRecentSearchTermsUseCase: GetRecentSearchTermsUseCase {
    var recentTerms = [String]()
    var recentSearchGatewayShouldFail = false

    func invoke() async throws -> [String] {
        if recentSearchGatewayShouldFail {
            throw RecentSearchError.unableToFetch
        } else {
            return recentTerms
        }
    }
}
