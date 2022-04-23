import XCTest
@testable import WeatherApp

@MainActor final class CurrentWeatherPresenterTests: XCTestCase {
    private var getCurrentWeatherUseCase: FakeGetCurrentWeatherUseCase!
    private var getRecentSearchTermsUseCase: FakeGetRecentSearchTermsUseCase!
    private var saveSearchTermUseCase: FakeSaveSearchTermUseCase!
    private var view: CurrentWeatherViewSpy!
    private var router: CurrentWeatherRouterSpy!
    private var presenter: CurrentWeatherPresenter!

    private let recentTerms = ["New York", "Lisbon", "Rio de Janeiro"]

    @MainActor override func setUp() {
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

    @MainActor override func tearDown() {
        super.tearDown()
        presenter = nil
        router = nil
        view = nil
        saveSearchTermUseCase = nil
        getRecentSearchTermsUseCase = nil
        getCurrentWeatherUseCase = nil
    }

    // MARK: - viewDidLoad

    func test_WHEN_viewDidLoad_THEN_it_should_display_recent_terms() {
        getRecentSearchTermsUseCase.recentTerms = recentTerms

        let displayRecentTermsExpectation = expectation(description: "display recent terms expectation")
        view.displayRecentTermsCompletion = {
            displayRecentTermsExpectation.fulfill()
        }

        presenter.viewDidLoad()

        waitForExpectations(timeout: 5)

        XCTAssertEqual(view.recentTerms, RecentSearchTermViewModel.stubList(from: recentTerms))
    }

    // MARK: - Search & Recent Search List

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_display_and_hide_loading_and_display_current_weather() {
        getCurrentWeatherUseCase.weather = .nyDummy

        let displayWeatherExpectation = expectation(description: "display weather expectation")
        router.displayWeatherCompletion = {
            displayWeatherExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 5)

        XCTAssertEqual(router.weatherViewModel, .stub(from: .nyDummy))
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertFalse(router.displayErrorCalled)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_save_term_and_refresh_recent_terms() {
        getCurrentWeatherUseCase.weather = .nyDummy
        getRecentSearchTermsUseCase.recentTerms = recentTerms

        let refreshRecentTermsExpectation = expectation(description: "refresh recent terms expectation")
        view.displayRecentTermsCompletion = {
            refreshRecentTermsExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 5)

        XCTAssertEqual(saveSearchTermUseCase.term, "New York")
        XCTAssertEqual(view.recentTerms, RecentSearchTermViewModel.stubList(from: recentTerms))
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_and_hide_loading_and_display_error() {
        getCurrentWeatherUseCase.weather = nil

        let displayErrorExpectation = expectation(description: "display error expectation")
        router.displayErrorCompletion = {
            displayErrorExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 5)

        XCTAssertTrue(router.displayErrorCalled)
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(router.weatherViewModel)
    }

    // MARK: - Recent Search List Tap

    func test_GIVEN_recent_search_terms_WHEN_the_last_term_is_tapped_THEN_it_should_update_search_view_with_term_and_perform_search_with_the_term_and_move_the_term_to_the_top_of_the_list() {
        getRecentSearchTermsUseCase.recentTerms = recentTerms

        let displayRecentTermsExpectation = expectation(description: "display recent terms expectation")
        view.displayRecentTermsCompletion = {
            displayRecentTermsExpectation.fulfill()
        }

        presenter.viewDidLoad()

        waitForExpectations(timeout: 5)

        let refreshedRecentTerms = ["Rio de Janeiro", "New York", "Lisbon"]

        getCurrentWeatherUseCase.weather = .rjDummy
        getRecentSearchTermsUseCase.recentTerms = refreshedRecentTerms

        let displayWeatherExpectation = expectation(description: "display weather expectation")
        router.displayWeatherCompletion = {
            displayWeatherExpectation.fulfill()
        }

        let refreshRecentTermsExpectation = expectation(description: "refresh recent terms expectation")
        view.displayRecentTermsCompletion = {
            refreshRecentTermsExpectation.fulfill()
        }

        presenter.searchTermTapped(at: 2)

        waitForExpectations(timeout: 5)

        XCTAssertEqual(router.weatherViewModel, .stub(from: .rjDummy))
        XCTAssertEqual(view.searchQuery, "Rio de Janeiro")
        XCTAssertEqual(saveSearchTermUseCase.term, "Rio de Janeiro")
        XCTAssertEqual(view.recentTerms, RecentSearchTermViewModel.stubList(from: refreshedRecentTerms))
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertFalse(router.displayErrorCalled)
    }
}
