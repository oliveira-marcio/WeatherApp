import Foundation

protocol GetCurrentWeatherUseCase {
    func invoke(query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void)
}

protocol GetCurrentWeatherUseCaseDependenciesResolvable {
    var weatherGateway: WeatherGateway { get }
}

final class GetCurrentWeatherUseCaseImplementation: GetCurrentWeatherUseCase {
    private let weatherGateway: WeatherGateway

    init(weatherGateway: WeatherGateway) {
        self.weatherGateway = weatherGateway
    }

    convenience init(dependencies: GetCurrentWeatherUseCaseDependenciesResolvable) {
        self.init(weatherGateway: dependencies.weatherGateway)
    }

    func invoke(query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        weatherGateway.fetchCurrentWeather(for: query, completion: completion)
    }
}
