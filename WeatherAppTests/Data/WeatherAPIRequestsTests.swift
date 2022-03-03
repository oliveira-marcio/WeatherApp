import XCTest
@testable import WeatherApp

final class WeatherAPIRequestsTests: XCTestCase {

    func test_GIVEN_base_url_and_api_key_and_query_WHEN_GetCurrentWeatherRequest_is_created_THEN_the_payload_is_correctly_build() {

        let baseURL = URL(string: "https://www.foo.com")!
        let apiKey = "apiKey"
        let query = "New York"

        let request = WeatherAPI.GetCurrentWeatherRequest(baseURL: baseURL, apiKey: apiKey, query: query).urlRequest

        XCTAssertEqual(request.url?.absoluteString, "https://www.foo.com/current?access_key=apiKey&query=New%20York")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(request.httpBody, nil)
    }
}
