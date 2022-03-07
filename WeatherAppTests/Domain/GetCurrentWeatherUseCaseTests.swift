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

    func test_GIVEN_query_WHEN_use_case_is_invoked_THEN_weather_gateway_should_return_current_weather_for_query() {
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))

        let invokeExpectation = expectation(description: "invoke expectation")
        var actualWeather: Weather?

        getCurrentWeatherUseCase.invoke(query: "New York") { result in
            actualWeather = try? result.get()
            invokeExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(weatherGateway.query, "New York")
        XCTAssertEqual(actualWeather, .nyDummy)
    }

    func test_GIVEN_query_WHEN_use_case_is_invoked_and_weather_gateway_fails_THEN_weather_gateway_should_return_error_for_query() {
        weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))

        let invokeExpectation = expectation(description: "invoke expectation")
        var error: WeatherError?

        getCurrentWeatherUseCase.invoke(query: "New York") { result in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            invokeExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(weatherGateway.query, "New York")
        XCTAssertEqual(error, .operationFailed)
    }
}
