import Foundation

protocol GetCurrentWeatherUseCase {
    func invoke(query: String) async throws -> Weather
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

    func invoke(query: String) async throws -> Weather {
        try await weatherGateway.fetchCurrentWeather(for: query)
    }
}
