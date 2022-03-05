@testable import WeatherApp

final class FakeGetCurrentWeatherUseCase: GetCurrentWeatherUseCase {
    var weather: Weather?
    var weatherGatewayShouldFail = false

    func invoke(query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        completion(weatherGatewayShouldFail ? .failure(.operationFailed) : .success(weather!))
    }
}
