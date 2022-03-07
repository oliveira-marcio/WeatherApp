import XCTest
@testable import WeatherApp

final class CurrentWeatherComponentTests: XCTestCase {
    private var environment: ComponentTestEnvironment!
    private var presenter: CurrentWeatherPresenter!
    private var view: CurrentWeatherViewSpy!
    private var router: CurrentWeatherRouterSpy!
    private var weatherGateway: MockWeatherGateway!
    private var recentSearchGateway: MockRecentSearchGateway!

    private let recentTerms = ["New York", "Lisbon", "Rio de Janeiro"]

    override func setUp() {
        super.setUp()
        environment = ComponentTestEnvironment.bootstrap()
        presenter = environment.presentation.currentWeatherPresenter
        view = environment.presentation.currentWeatherView
        router = environment.presentation.currentWeatherRouter
        weatherGateway = environment.data.weatherGateway as? MockWeatherGateway
        recentSearchGateway = environment.data.recentSearchGateway as? MockRecentSearchGateway
    }

    override func tearDown() {
        super.tearDown()
        environment = nil
    }

    // MARK: - viewDidLoad

    func test_WHEN_viewDidLoad_THEN_it_should_display_recent_terms() {
        recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms))

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
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))

        let displayWeatherExpectation = expectation(description: "display weather expectation")
        router.displayWeatherCompletion = {
            displayWeatherExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 5)

        XCTAssertEqual(weatherGateway.query, "New York")
        XCTAssertEqual(router.weatherViewModel, .stub(from: .nyDummy))
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(router.errorViewModel)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_save_term_and_refresh_recent_terms() {
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))
        recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms))

        let refreshRecentTermsExpectation = expectation(description: "refresh recent terms expectation")
        view.displayRecentTermsCompletion = {
            refreshRecentTermsExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 5)

        XCTAssertEqual(recentSearchGateway.term, "New York")
        XCTAssertEqual(view.recentTerms, RecentSearchTermViewModel.stubList(from: recentTerms))
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_and_hide_loading_and_display_error() {
        weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))

        let displayErrorExpectation = expectation(description: "display error expectation")
        router.displayErrorCompletion = {
            displayErrorExpectation.fulfill()
        }

        presenter.onSearchButtonTapped(query: "New York")

        waitForExpectations(timeout: 5)

        XCTAssertEqual(weatherGateway.query, "New York")
        XCTAssertEqual(router.errorViewModel, .dummy)
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(router.weatherViewModel)
    }

    // MARK: - Recent Search List Tap

    func test_GIVEN_recent_search_terms_WHEN_the_last_term_is_tapped_THEN_it_should_update_search_view_with_term_and_perform_search_with_the_term_and_move_the_term_to_the_top_of_the_list() {
        let refreshedRecentTerms = ["Rio de Janeiro", "New York", "Lisbon"]

        recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms),
                                                   .success(refreshedRecentTerms))
        
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.rjDummy))

        let displayRecentTermsExpectation = expectation(description: "display recent terms expectation")
        view.displayRecentTermsCompletion = {
            displayRecentTermsExpectation.fulfill()
        }

        presenter.viewDidLoad()

        waitForExpectations(timeout: 5)

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
        XCTAssertEqual(recentSearchGateway.term, "Rio de Janeiro")
        XCTAssertEqual(weatherGateway.query, "Rio de Janeiro")
        XCTAssertEqual(view.recentTerms, RecentSearchTermViewModel.stubList(from: refreshedRecentTerms))
        XCTAssertEqual(view.loadingCalls, [true, false])
        XCTAssertNil(router.errorViewModel)
    }
}
