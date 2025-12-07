import Testing
import Foundation
@testable import WeatherApp

@Suite
struct WeatherAPIRequestsTests {

    @Test
    func GIVEN_base_url_and_api_key_and_query_WHEN_GetCurrentWeatherRequest_is_created_THEN_the_payload_is_correctly_build() {

        let baseURL = URL(string: "https://www.foo.com")!
        let apiKey = "apiKey"
        let query = "New York"

        let request = WeatherAPI.GetCurrentWeatherRequest(baseURL: baseURL, apiKey: apiKey, query: query).urlRequest

        #expect(request.url?.absoluteString == "https://www.foo.com/current?access_key=apiKey&query=New%20York")
        #expect(request.httpMethod == "GET")
        #expect(request.allHTTPHeaderFields?.count == 2)
        #expect(request.allHTTPHeaderFields?["Accept"] == "application/json")
        #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json")
        #expect(request.httpBody == nil)
    }
}
