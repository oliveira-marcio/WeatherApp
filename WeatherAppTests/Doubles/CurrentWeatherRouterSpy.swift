@testable import WeatherApp

final class CurrentWeatherRouterSpy: CurrentWeatherRouter {
    var weatherViewModel: CurrentWeatherViewModel?
    var errorViewModel: ErrorViewModel?

    var displayWeatherCompletion: (() -> ())?
    var displayErrorCompletion: (() -> ())?

    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        displayWeatherCompletion?()
    }

    func displayError(errorViewModel: ErrorViewModel) {
        self.errorViewModel = errorViewModel
        displayErrorCompletion?()
    }
}
