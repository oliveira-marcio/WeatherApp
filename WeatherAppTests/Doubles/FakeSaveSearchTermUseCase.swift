@testable import WeatherApp

final class FakeSaveSearchTermUseCase: SaveSearchTermUseCase {
    var recentSearchGatewayShouldFail = false
    var term: String?

    func invoke(term: String, completion: @escaping (RecentSearchError?) -> Void) {
        self.term = term
        completion(recentSearchGatewayShouldFail ? .unableToInsert : nil)
    }
}