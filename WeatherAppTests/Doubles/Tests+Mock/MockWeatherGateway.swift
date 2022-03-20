import Foundation
@testable import WeatherApp

final class MockWeatherGateway: WeatherGateway {
    var queue = DispatchQueue(label: "com.marcio.WeatherApp.MockWeatherGateway")

    var fetchCurrentWeatherDelay: Double
    var fetchCurrentWeatherQueue = MockResultQueue<Weather, WeatherError>()
    var query: String?

    init() {
        fetchCurrentWeatherDelay = 1
        fetchCurrentWeatherQueue.set(.success(.nyDummy))
    }

    func fetchCurrentWeather(for query: String) async throws -> Weather {
        self.query = query
        try await Task.sleep(nanoseconds: UInt64(fetchCurrentWeatherDelay * Double(NSEC_PER_SEC)))
        switch self.fetchCurrentWeatherQueue.dequeue() {
        case let .success(weather): return weather
        case let .failure(error): throw error
        }
    }
}
