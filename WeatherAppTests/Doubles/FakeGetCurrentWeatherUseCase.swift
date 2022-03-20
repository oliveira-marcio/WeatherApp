@testable import WeatherApp

final class FakeGetCurrentWeatherUseCase: GetCurrentWeatherUseCase {
    var weather: Weather?
    var weatherGatewayShouldFail = false

    func invoke(query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        completion(weatherGatewayShouldFail ? .failure(.operationFailed) : .success(weather!))
    }

    func invoke(query: String) async throws -> Weather {
        guard let weather = weather else {
            throw WeatherError.operationFailed
        }

        return weather
    }
}
