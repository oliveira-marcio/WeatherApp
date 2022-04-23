import XCTest
@testable import WeatherApp

final class GetCurrentWeatherUseCaseTests: XCTestCase {
    private var weatherGateway: MockWeatherGateway!
    private var getCurrentWeatherUseCase: GetCurrentWeatherUseCaseImplementation!

    override func setUp() {
        super.setUp()
        weatherGateway = MockWeatherGateway()
        getCurrentWeatherUseCase = GetCurrentWeatherUseCaseImplementation(weatherGateway: weatherGateway)
    }

    override func tearDown() {
        super.tearDown()
        getCurrentWeatherUseCase = nil
        weatherGateway = nil
    }

    func test_GIVEN_query_WHEN_use_case_is_invoked_THEN_weather_gateway_should_return_current_weather_for_query() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))

        let actualWeather: Weather? = try? await getCurrentWeatherUseCase.invoke(query: "New York")

        XCTAssertEqual(weatherGateway.query, "New York")
        XCTAssertEqual(actualWeather, .nyDummy)
    }

    func test_GIVEN_query_WHEN_use_case_is_invoked_and_weather_gateway_fails_THEN_weather_gateway_should_return_error_for_query() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))

        var errorResult: WeatherError?

        do {
            _ = try await getCurrentWeatherUseCase.invoke(query: "New York")
        } catch {
            errorResult = error as? WeatherError
        }

        XCTAssertEqual(weatherGateway.query, "New York")
        XCTAssertEqual(errorResult, .operationFailed)
    }
}
