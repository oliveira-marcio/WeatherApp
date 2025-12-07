import Testing
@testable import WeatherApp

@Suite
struct GetCurrentWeatherUseCaseTests {
    private let weatherGateway: MockWeatherGateway
    private let getCurrentWeatherUseCase: GetCurrentWeatherUseCaseImplementation

    init() {
        weatherGateway = MockWeatherGateway()
        getCurrentWeatherUseCase = GetCurrentWeatherUseCaseImplementation(weatherGateway: weatherGateway)
    }

    @Test
    func GIVEN_query_WHEN_use_case_is_invoked_THEN_weather_gateway_should_return_current_weather_for_query() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))

        let actualWeather: Weather? = try? await getCurrentWeatherUseCase.invoke(query: "New York")

        #expect(weatherGateway.query == "New York")
        #expect(actualWeather == .nyDummy)
    }

    @Test
    func GIVEN_query_WHEN_use_case_is_invoked_and_weather_gateway_fails_THEN_weather_gateway_should_return_error_for_query() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))

        await #expect(throws: WeatherError.operationFailed) {
            try await getCurrentWeatherUseCase.invoke(query: "New York")
        }

        #expect(weatherGateway.query == "New York")
    }
}
