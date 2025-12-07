import Testing
@testable import WeatherApp

@Suite
struct CurrentWeatherComponentTests {
    private let environment: ComponentTestEnvironment
    private let presenter: CurrentWeatherPresenter
    private let view: CurrentWeatherViewSpy
    private let router: CurrentWeatherRouterSpy
    private let weatherGateway: MockWeatherGateway
    private let recentSearchGateway: MockRecentSearchGateway

    private let recentTerms = ["New York", "Lisbon", "Rio de Janeiro"]

    init() {
        environment = ComponentTestEnvironment.bootstrap()
        presenter = environment.presentation.currentWeatherPresenter
        view = environment.presentation.currentWeatherView
        router = environment.presentation.currentWeatherRouter
        weatherGateway = environment.data.weatherGateway as! MockWeatherGateway
        recentSearchGateway = environment.data.recentSearchGateway as! MockRecentSearchGateway
    }

    // MARK: - viewDidLoad

    @Test
    func WHEN_viewDidLoad_THEN_it_should_display_recent_terms() async {
        recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms))

        await confirmation("display recent terms") { viewDidLoad in
            view.displayRecentTermsCompletion = {
                viewDidLoad()
            }
            
            await presenter.viewDidLoad()
        }

        #expect(view.recentTerms == RecentSearchTermViewModel.stubList(from: recentTerms))
    }

    // MARK: - Search & Recent Search List

    @Test
    func GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_display_and_hide_loading_and_display_current_weather() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))

        await confirmation("display weather") { searchButtonTapped in
            router.displayWeatherCompletion = {
                searchButtonTapped()
            }

            await presenter.onSearchButtonTapped(query: "New York")
        }

        #expect(weatherGateway.query == "New York")
        #expect(router.weatherViewModel == .stub(from: .nyDummy))
        #expect(view.loadingCalls == [true, false])
        #expect(router.displayErrorCalled == false)
    }

    @Test
    func GIVEN_query_WHEN_search_button_is_tapped_THEN_it_should_save_term_and_refresh_recent_terms() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))
        recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms))

        await confirmation("refresh recent terms") { searchButtonTapped in
            view.displayRecentTermsCompletion = {
                searchButtonTapped()
            }

            await presenter.onSearchButtonTapped(query: "New York")
        }

        #expect(recentSearchGateway.term == "New York")
        #expect(view.recentTerms == RecentSearchTermViewModel.stubList(from: recentTerms))
    }

    @Test
    func GIVEN_query_WHEN_search_button_is_tapped_and_request_fails_THEN_it_should_display_and_hide_loading_and_display_error() async {
        weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))

        await confirmation("display error") { searchButtonTapped in
            router.displayErrorCompletion = {
                searchButtonTapped()
            }

            await presenter.onSearchButtonTapped(query: "New York")
        }

        #expect(weatherGateway.query == "New York")
        #expect(router.displayErrorCalled == true)
        #expect(view.loadingCalls == [true, false])
        #expect(router.weatherViewModel == nil)
    }

    // MARK: - Recent Search List Tap
 
    @Test
    func GIVEN_recent_search_terms_WHEN_the_last_term_is_tapped_THEN_it_should_update_search_view_with_term_and_perform_search_with_the_term_and_move_the_term_to_the_top_of_the_list() async {
        let refreshedRecentTerms = ["Rio de Janeiro", "New York", "Lisbon"]

        recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms),
                                                   .success(refreshedRecentTerms))
        
        weatherGateway.fetchCurrentWeatherQueue.set(.success(.rjDummy))

        await confirmation("display weather and refresh recent terms", expectedCount: 3) { searchButtonTapped in
            view.displayRecentTermsCompletion = {
                searchButtonTapped()
            }
            
            router.displayWeatherCompletion = {
                searchButtonTapped()
            }
            
            view.displayRecentTermsCompletion = {
                searchButtonTapped()
            }

            await presenter.viewDidLoad()
            await presenter.searchTermTapped(at: 2)
        }
        
        #expect(router.weatherViewModel == .stub(from: .rjDummy))
        #expect(view.searchQuery == "Rio de Janeiro")
        #expect(recentSearchGateway.term == "Rio de Janeiro")
        #expect(weatherGateway.query == "Rio de Janeiro")
        #expect(view.recentTerms == RecentSearchTermViewModel.stubList(from: refreshedRecentTerms))
        #expect(view.loadingCalls == [true, false])
        #expect(router.displayErrorCalled == false)
    }
}
