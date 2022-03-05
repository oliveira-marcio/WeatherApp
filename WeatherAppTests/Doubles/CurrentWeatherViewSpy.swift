@testable import WeatherApp

final class CurrentWeatherViewSpy: CurrentWeatherView {
    var presenter: CurrentWeatherPresenter!
    var weather: Weather?
    var loadingCalls = [Bool]()
    var errorTitle: String?
    var errorMessage: String?

    var displayWeatherCompletion: (() -> ())?
    var displayLoadingCompletion: (() -> ())?
    var displayErrorCompletion: (() -> ())?

    func display(weather: Weather) {
        self.weather = weather
        displayWeatherCompletion?()
    }

    func display(loading: Bool) {
        loadingCalls.append(loading)
        displayLoadingCompletion?()
    }

    func display(title: String, error: String) {
        errorTitle = title
        errorMessage = error
        displayErrorCompletion?()
    }
}
