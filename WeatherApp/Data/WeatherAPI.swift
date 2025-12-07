import Foundation

struct WeatherAPI {
    struct GetCurrentWeatherRequest: URLRequestable {

        private let url: URL!

        init(baseURL: URL, apiKey: String, query: String) {

            var components = URLComponents()
            components.path = "/current"
            components.queryItems = [
                URLQueryItem(name: "access_key", value: apiKey),
                URLQueryItem(name: "query", value: query)
            ]

            url = components.url(relativeTo: baseURL)
        }

        var urlRequest: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }
    }
}
