@testable import WeatherApp

final class CurrentWeatherRouterSpy: CurrentWeatherRouter {
    var weatherViewModel: CurrentWeatherViewModel?
    var errorTitle: String?
    var errorMessage: String?

    var displayWeatherCompletion: (() -> ())?
    var displayErrorCompletion: (() -> ())?

    func displayWeatherResults(weatherViewModel: CurrentWeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        displayWeatherCompletion?()
    }

    func displayError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        displayErrorCompletion?()
    }
}
