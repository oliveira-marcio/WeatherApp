@testable import WeatherApp

final class CurrentWeatherViewSpy: CurrentWeatherView {
    var presenter: CurrentWeatherPresenter!
    var loadingCalls = [Bool]()
    var recentTerms: [RecentSearchTermViewModel]?
    var searchQuery: String?

    var displayRecentTermsCompletion: (() -> ())?

    func display(loading: Bool) {
        loadingCalls.append(loading)
    }

    func display(recentTerms: [RecentSearchTermViewModel]) {
        self.recentTerms = recentTerms
        displayRecentTermsCompletion?()
    }

    func display(searchQuery: String) {
        self.searchQuery = searchQuery
    }
}
