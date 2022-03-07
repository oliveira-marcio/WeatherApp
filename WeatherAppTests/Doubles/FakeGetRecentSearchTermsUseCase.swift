@testable import WeatherApp

final class FakeGetRecentSearchTermsUseCase: GetRecentSearchTermsUseCase {
    var recentTerms = [String]()
    var recentSearchGatewayShouldFail = false

    func invoke(completion: @escaping (Result<[String], RecentSearchError>) -> Void) {
        completion(recentSearchGatewayShouldFail ? .failure(.unableToFetch) : .success(recentTerms))
    }
}
