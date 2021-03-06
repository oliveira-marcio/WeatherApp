import Foundation

enum WeatherError: Error {
    case operationFailed
}

protocol WeatherGateway {
    func fetchCurrentWeather(for query: String) async throws -> Weather
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

    func fetchCurrentWeather(for query: String) async throws -> Weather {
        let request = WeatherAPI.GetCurrentWeatherRequest(baseURL: baseURL, apiKey: apiKey, query: query)

        do {
            let weatherEntity: WeatherAPI.WeatherEntity = try await requestExecutor.execute(request: request)
            return Weather(from: weatherEntity)
        } catch {
            throw WeatherError.operationFailed
        }
    }
}
