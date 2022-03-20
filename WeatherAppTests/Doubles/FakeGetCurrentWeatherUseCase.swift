@testable import WeatherApp

final class FakeGetCurrentWeatherUseCase: GetCurrentWeatherUseCase {
    var weather: Weather?

    func invoke(query: String) async throws -> Weather {
        guard let weather = weather else {
            throw WeatherError.operationFailed
        }

        return weather
    }
}
