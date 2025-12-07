import Testing
import Foundation
@testable import WeatherApp

@Suite
struct WeatherGatewayTests {
    private let baseURL = URL(string: "https://www.foo.com")!
    private let apiKey = "apiKey"

    private let urlSessionStub: URLSessionStub
    private let requestExecutor: RequestExecutorImplementation
    private let gateway: WeatherGatewayImplementation

    init() {
        urlSessionStub = URLSessionStub()
        requestExecutor = RequestExecutorImplementation(urlSession: urlSessionStub)
        gateway = WeatherGatewayImplementation(baseURL: baseURL, apiKey: apiKey, requestExecutor: requestExecutor)
    }

    @Test
    func GIVEN_query_WHEN_fetchCurrentWeather_is_called_THEN_it_should_execute_proper_request() async {
        let requestExecutor = RequestExecutorSpy()
        let gateway = WeatherGatewayImplementation(baseURL: baseURL, apiKey: apiKey, requestExecutor: requestExecutor)

        _ = try? await gateway.fetchCurrentWeather(for: "New York")

        #expect(requestExecutor.request?.urlRequest.description == "https://www.foo.com/current?access_key=apiKey&query=New%20York")
    }

    @Test
    func GIVEN_query_WHEN_fetchCurrentWeather_is_called_THEN_it_should_return_current_weather() async {
        let responseData = """
        {
            "request": {
                "type": "City",
                "query": "New York, United States of America",
                "language": "en",
                "unit": "m"
            },
            "location": {
                "name": "New York",
                "country": "United States of America",
                "region": "New York",
                "lat": "40.714",
                "lon": "-74.006",
                "timezone_id": "America/New_York",
                "localtime": "2022-03-03 12:40",
                "localtime_epoch": 1646311200,
                "utc_offset": "-5.0"
            },
            "current": {
                "observation_time": "05:40 PM",
                "temperature": 4,
                "weather_code": 116,
                "weather_icons": [
                    "https://assets.weatherstack.com/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png"
                ],
                "weather_descriptions": [
                    "Partly cloudy"
                ],
                "wind_speed": 24,
                "wind_degree": 320,
                "wind_dir": "NW",
                "pressure": 1018,
                "precip": 0,
                "humidity": 37,
                "cloudcover": 50,
                "feelslike": 0,
                "uv_index": 2,
                "visibility": 16,
                "is_day": "yes"
            }
        }
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        let actualWeather = try? await gateway.fetchCurrentWeather(for: "New York")

        #expect(actualWeather == .nyDummy)
    }

    @Test
    func GIVEN_query_WHEN_fetchCurrentWeather_is_called_and_request_fails_THEN_it_should_return_error() async {
        urlSessionStub.enqueue(response: (data: "".data(using: .utf8),
                                          response: HTTPURLResponse(statusCode: 500),
                                          error: nil))

        await #expect(throws: WeatherError.operationFailed) {
            try await gateway.fetchCurrentWeather(for: "New York")
        }
    }
}
