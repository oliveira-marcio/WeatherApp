import XCTest
@testable import WeatherApp

final class CurrentWeatherPresenterTests: XCTestCase {
    private var getCurrentWeatherUseCase: FakeGetCurrentWeatherUseCase!
    private var getRecentSearchTermsUseCase: FakeGetRecentSearchTermsUseCase!
    private var saveSearchTermUseCase: FakeSaveSearchTermUseCase!
    private var view: CurrentWeatherViewSpy!
    private var router: CurrentWeatherRouterSpy!
    private var presenter: CurrentWeatherPresenter!

    private let recentTerms = ["New York", "Lisbon", "Rio de Janeiro"]

    override func setUp() {
        super.setUp()
        getCurrentWeatherUseCase = FakeGetCurrentWeatherUseCase()
        getRecentSearchTermsUseCase = FakeGetRecentSearchTermsUseCase()
        saveSearchTermUseCase = FakeSaveSearchTermUseCase()
        view = CurrentWeatherViewSpy()
        router = CurrentWeatherRouterSpy()
        presenter = CurrentWeatherPresenter(view: view,
                                            router: router,
                                            getCurrentWeatherUseCase: getCurrentWeatherUseCase,
                                            getRecentSearchTermsUseCase: getRecentSearchTermsUseCase,
                                            saveSearchTermUseCase: saveSearchTermUseCase)
    }

    override func tearDown() {
        super.tearDown()
        presenter = nil
        router = nil
        view = nil
        saveSearchTermUseCase = nil
        getRecentSearchTermsUseCase = nil
        getCurrentWeatherUseCase = nil
    }

    func test_WHEN_viewDidLoad_THEN_it_should_display_recent_terms() {
        getRecentSearchTermsUseCase.recentTerms = recentTerms

        let displayRecentTermsExpectation = expectation(description: "display recent terms expectation")
        view.displayRecentTermsCompletion = {
            displayRecentTermsExpectation.fulfill()
        }

        presenter.viewDidLoad()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(view.recentTerms, recentTerms)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_display_and_dide_loading_and_display_current_weather() {
        getCurrentWeatherUseCase.weather = .nyDummy
        getCurrentWeatherUseCase.weatherGatewayShouldFail = false

        let displayWeatherExpectation = expectation(description: "display weather expectation")
        router.displayWeatherCompletion = {
            displayWeatherExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 1)

        XCTAssertEqual(router.weatherViewModel, .stub(from: .nyDummy))
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(router.errorViewModel)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_and_dide_loading_and_display_error() {
        getCurrentWeatherUseCase.weather = .nyDummy
        getCurrentWeatherUseCase.weatherGatewayShouldFail = true

        let displayErrorExpectation = expectation(description: "display error expectation")
        router.displayErrorCompletion = {
            displayErrorExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 1)

        XCTAssertEqual(router.errorViewModel, .dummy)
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(router.weatherViewModel)
    }
}
