@testable import WeatherApp

final class FakeSaveSearchTermUseCase: SaveSearchTermUseCase {
    var recentSearchGatewayShouldFail = false

    func invoke(term: String, completion: @escaping (RecentSearchError?) -> Void) {
        completion(recentSearchGatewayShouldFail ? .unableToInsert : nil)
    }
}
