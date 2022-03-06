import Foundation
@testable import WeatherApp

final class MockWeatherGateway: WeatherGateway {
    var queue = DispatchQueue(label: "com.marcio.WeatherApp.MockWeatherGateway")

    var fetchCurrentWeatherDelay = 0
    var fetchCurrentWeatherQueue = MockResultQueue<Weather, WeatherError>()
    var query: String?

    func fetchCurrentWeather(for query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        self.query = query
        queue.asyncAfter(deadline: .now() + .seconds(fetchCurrentWeatherDelay), flags: .barrier) { [unowned self] in
            completion(self.fetchCurrentWeatherQueue.dequeue())
        }
    }
}
