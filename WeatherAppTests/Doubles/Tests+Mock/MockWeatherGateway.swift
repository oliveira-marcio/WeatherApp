import Foundation
@testable import WeatherApp

final class MockWeatherGateway: WeatherGateway {
    var queue = DispatchQueue(label: "com.marcio.WeatherApp.MockWeatherGateway")

    var fetchCurrentWeatherDelay: Int
    var fetchCurrentWeatherQueue = MockResultQueue<Weather, WeatherError>()
    var query: String?

    init() {
        fetchCurrentWeatherDelay = 1
        fetchCurrentWeatherQueue.set(.success(.nyDummy))
    }

    func fetchCurrentWeather(for query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        self.query = query
        queue.asyncAfter(deadline: .now() + .seconds(fetchCurrentWeatherDelay), flags: .barrier) { [unowned self] in
            completion(self.fetchCurrentWeatherQueue.dequeue())
        }
    }

    func fetchCurrentWeather(for query: String) async throws -> Weather {
        switch fetchCurrentWeatherQueue.dequeue() {
        case let .success(weather): return weather
        case let .failure(error): throw error
        }
    }
}
