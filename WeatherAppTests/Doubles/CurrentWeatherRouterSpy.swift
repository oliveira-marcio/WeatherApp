@testable import WeatherApp

final class CurrentWeatherRouterSpy: CurrentWeatherRouter {
    var weatherViewModel: CurrentWeatherViewModel?
    var displayErrorCalled = false

    var displayWeatherCompletion: (() -> ())?
    var displayErrorCompletion: (() -> ())?

    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        displayWeatherCompletion?()
    }

    func displayError() {
        displayErrorCalled = true
        displayErrorCompletion?()
    }
}
