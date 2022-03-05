import Foundation

final class GetCurrentWeatherUseCaseImplementation {
    private let weatherGateway: WeatherGateway

    init(weatherGateway: WeatherGateway) {
        self.weatherGateway = weatherGateway
    }

    func invoke(query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        weatherGateway.fetchCurrentWeather(for: query, completion: completion)
    }
}
