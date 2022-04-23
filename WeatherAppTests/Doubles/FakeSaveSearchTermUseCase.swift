@testable import WeatherApp

final class FakeSaveSearchTermUseCase: SaveSearchTermUseCase {
    var recentSearchGatewayShouldFail = false
    var term: String?

    func invoke(term: String) async throws {
        self.term = term
        guard recentSearchGatewayShouldFail else { return }
        throw RecentSearchError.unableToInsert
    }
}
