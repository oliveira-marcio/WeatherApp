import XCTest
@testable import WeatherApp

final class CurrentWeatherPresenterTests: XCTestCase {
    private var getCurrentWeatherUseCase: FakeGetCurrentWeatherUseCase!
    private var view: CurrentWeatherViewSpy!
    private var presenter: CurrentWeatherPresenter!

    override func setUp() {
        super.setUp()
        getCurrentWeatherUseCase = FakeGetCurrentWeatherUseCase()
        view = CurrentWeatherViewSpy()
        presenter = CurrentWeatherPresenter(view: view, getCurrentWeatherUseCase: getCurrentWeatherUseCase)
    }

    override func tearDown() {
        super.tearDown()
        presenter = nil
        view = nil
        getCurrentWeatherUseCase = nil
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_display_and_dide_loading_and_display_current_weather() {
        getCurrentWeatherUseCase.weather = .nyDummy
        getCurrentWeatherUseCase.weatherGatewayShouldFail = false

        let displayWeatherExpectation = expectation(description: "display weather expectation")
        view.displayWeatherCompletion = {
            displayWeatherExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 1)

        XCTAssertEqual(view.weather, .nyDummy)
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(view.errorTitle)
        XCTAssertNil(view.errorMessage)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_and_dide_loading_and_display_error() {
        getCurrentWeatherUseCase.weather = .nyDummy
        getCurrentWeatherUseCase.weatherGatewayShouldFail = true

        let displayErrorExpectation = expectation(description: "display error expectation")
        view.displayErrorCompletion = {
            displayErrorExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 1)

        XCTAssertEqual(view.errorTitle, CurrentWeatherPresenter.LocalizationKeys.errorTitle)
        XCTAssertEqual(view.errorMessage, CurrentWeatherPresenter.LocalizationKeys.errorMessage)
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(view.weather)
    }
}
