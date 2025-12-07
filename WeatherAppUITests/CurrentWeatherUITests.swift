import XCTest
import Foundation

@MainActor
final class CurrentWeatherUITests: MockTestCase {
    let currentWeatherPageObject = CurrentWeatherPageObject()

    // MARK: - Scene load

    func test_WHEN_scene_loads_THEN_it_should_display_recent_search_terms() {
        navigateToCurrentWeather(with: .withRecentSearchTerms)

        let recentSearchTerms = ["New York", "Lisbon", "Rio de Janeiro"]

        XCTAssertTrue(currentWeatherPageObject.recentSearchTermsView.isHittable)
        XCTAssertEqual(currentWeatherPageObject.getRecentSearchStrings(), recentSearchTerms)
    }

    // MARK: - Search results & Error

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_display_current_weather_results() {
        navigateToCurrentWeather(with: .withCurrentWeather)

        performSearch(with: "New York")

        waitForElementToAppear(currentWeatherPageObject.currentWeatherSheet)

        XCTAssertTrue(currentWeatherPageObject.nyCurrentWeatherLocation.exists)
        XCTAssertTrue(currentWeatherPageObject.nyCurrentWeatherTemperature.exists)
        XCTAssertTrue(currentWeatherPageObject.nyCurrentWeatherDescription.exists)
    }

    // TODO: Fix action sheet dismiss not reachable
    func test_GIVEN_current_weather_results_and_scene_unhittable_WHEN_dismiss_is_tapped_THEN_it_should_dismiss_results_and_scene_is_hittable_again() {
        navigateToCurrentWeather(with: .withCurrentWeather)

        XCTAssertTrue(currentWeatherPageObject.recentSearchTermsView.isHittable)

        performSearch(with: "New York")

        waitForElementToAppear(currentWeatherPageObject.currentWeatherSheet)

        XCTAssertFalse(currentWeatherPageObject.recentSearchTermsView.isHittable)

        currentWeatherPageObject.currentWeatherSheetDismissButton.tap()

        XCTAssertTrue(currentWeatherPageObject.recentSearchTermsView.isHittable)
        XCTAssertFalse(currentWeatherPageObject.currentWeatherSheet.exists)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_error() {
        navigateToCurrentWeather(with: .withCurrentWeatherError)

        performSearch(with: "New York")

        waitForElementToAppear(currentWeatherPageObject.currentWeatherErrorAlert)

        XCTAssertTrue(currentWeatherPageObject.currentWeatherErrorAlert.exists)
    }

    // MARK: - Loading

    // TODO: Fix action sheet dismiss not reachable
    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_display_loading_view_before_current_weather_results_then_hide_it() {
        navigateToCurrentWeather(with: .withLoadingCurrentWeather, .withRecentSearchTerms)

        performSearch(with: "New York")

        waitForElementToAppear(currentWeatherPageObject.loadingView)

        XCTAssertTrue(currentWeatherPageObject.loadingView.isHittable)
        XCTAssertFalse(currentWeatherPageObject.recentSearchTermsView.isHittable)

        waitForElementToAppear(currentWeatherPageObject.currentWeatherSheet)
        currentWeatherPageObject.currentWeatherSheetDismissButton.tap()

        XCTAssertFalse(currentWeatherPageObject.loadingView.isHittable)
        XCTAssertTrue(currentWeatherPageObject.recentSearchTermsView.isHittable)
    }

    func test_GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_loading_view_before_error_then_hide_it() {
        navigateToCurrentWeather(with: .withLoadingCurrentWeatherError, .withRecentSearchTerms)

        performSearch(with: "New York")

        waitForElementToAppear(currentWeatherPageObject.loadingView)

        XCTAssertTrue(currentWeatherPageObject.loadingView.isHittable)
        XCTAssertFalse(currentWeatherPageObject.recentSearchTermsView.isHittable)

        waitForElementToAppear(currentWeatherPageObject.currentWeatherErrorAlert)
        currentWeatherPageObject.currentWeatherErrorAlertDismissButton.tap()

        XCTAssertFalse(currentWeatherPageObject.loadingView.isHittable)
        XCTAssertTrue(currentWeatherPageObject.recentSearchTermsView.isHittable)
    }
    

    // MARK: - Recent Search Term List

    func test_GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_refresh_recent_search_terms() {
        navigateToCurrentWeather(with: .withCurrentWeather)

        let recentSearchTerms = ["Lisbon", "Rio de Janeiro"]

        XCTAssertEqual(currentWeatherPageObject.getRecentSearchStrings(), recentSearchTerms)

        performSearch(with: "New York")

        let refreshedRecentSearchTerms = ["New York", "Lisbon", "Rio de Janeiro"]

        XCTAssertEqual(currentWeatherPageObject.getRecentSearchStrings(), refreshedRecentSearchTerms)
    }

    func test_GIVEN_recent_search_terms_WHEN_the_last_term_is_tapped_THEN_it_should_update_search_view_with_term_and_perform_search_with_the_term_and_move_the_term_to_the_top_of_the_list() {
        navigateToCurrentWeather(with: .withTappedRecentSearchTerm)

        let recentSearchTerms = ["Lisbon", "Rio de Janeiro", "New York"]

        XCTAssertEqual(currentWeatherPageObject.getRecentSearchStrings(), recentSearchTerms)

        currentWeatherPageObject.findRecentSearchElement(with: "New York").tap()

        let refreshedRecentSearchTerms = ["New York", "Lisbon", "Rio de Janeiro"]

        waitForElementToAppear(currentWeatherPageObject.currentWeatherSheet)

        XCTAssertTrue(currentWeatherPageObject.nyCurrentWeatherLocation.exists)
        XCTAssertTrue(currentWeatherPageObject.nyCurrentWeatherTemperature.exists)
        XCTAssertTrue(currentWeatherPageObject.nyCurrentWeatherDescription.exists)
        XCTAssertEqual(currentWeatherPageObject.searchField.value as? String, "New York")
        XCTAssertEqual(currentWeatherPageObject.getRecentSearchStrings(), refreshedRecentSearchTerms)
    }

    private func performSearch(with query: String) {
        currentWeatherPageObject.searchField.tap()
        currentWeatherPageObject.searchField.typeText(query)
        currentWeatherPageObject.searchButton.tap()
    }

    private func navigateToCurrentWeather(with environment: LaunchEnvironmentKey ...) {
        setupApp(with: environment)

        XCTAssertTrue(currentWeatherPageObject.isOnPage)
    }
}
