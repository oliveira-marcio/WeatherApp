@testable import WeatherApp

final class CurrentWeatherViewSpy: CurrentWeatherView {
    var presenter: CurrentWeatherPresenter!
    var loadingCalls = [Bool]()
    var recentTerms: [String]?

    var displayRecentTermsCompletion: (() -> ())?

    func display(loading: Bool) {
        loadingCalls.append(loading)
    }

    func display(recentTerms: [String]) {
        self.recentTerms = recentTerms
        displayRecentTermsCompletion?()
    }
}
