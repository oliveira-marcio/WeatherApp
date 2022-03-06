@testable import WeatherApp

final class CurrentWeatherViewSpy: CurrentWeatherView {
    var presenter: CurrentWeatherPresenter!
    var loadingCalls = [Bool]()

    func display(loading: Bool) {
        loadingCalls.append(loading)
    }
}
