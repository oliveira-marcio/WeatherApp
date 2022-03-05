import Foundation

public enum WeatherError: Error {
    case operationFailed
}

protocol WeatherGateway {
    func fetchCurrentWeather(for query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void)
}

final class WeatherGatewayImplementation: WeatherGateway {
    private let baseURL: URL
    private let apiKey: String
    private let requestExecutor: RequestExecutor

    init(baseURL: URL, apiKey: String, requestExecutor: RequestExecutor) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.requestExecutor = requestExecutor
    }

    func fetchCurrentWeather(for query: String, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        let request = WeatherAPI.GetCurrentWeatherRequest(baseURL: baseURL, apiKey: apiKey, query: query)

        requestExecutor.execute(request: request) { (result: Result<WeatherAPI.WeatherEntity, ApiError>) in
            do {
                let weatherEntity = try result.get()
                completion(.success(Weather(from: weatherEntity)))
            } catch {
                completion(.failure(.operationFailed))
            }
        }
    }
}
