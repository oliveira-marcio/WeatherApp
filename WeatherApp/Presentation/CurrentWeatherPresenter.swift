import Foundation

protocol CurrentWeatherView: AnyObject {
    var presenter: CurrentWeatherPresenter! { get set }
    func display(loading: Bool)
    func display(recentTerms: [RecentSearchTermViewModel])
    func display(searchQuery: String)
}

@MainActor final class CurrentWeatherPresenter {
    private weak var view: CurrentWeatherView?
    private let router: CurrentWeatherRouter
    private let getCurrentWeatherUseCase: GetCurrentWeatherUseCase
    private let getRecentSearchTermsUseCase: GetRecentSearchTermsUseCase
    private let saveSearchTermUseCase: SaveSearchTermUseCase

    private var currentRecentTerms = [String]()

    init(view: CurrentWeatherView,
         router: CurrentWeatherRouter,
         getCurrentWeatherUseCase: GetCurrentWeatherUseCase,
         getRecentSearchTermsUseCase: GetRecentSearchTermsUseCase,
         saveSearchTermUseCase: SaveSearchTermUseCase) {
        self.view = view
        self.router = router
        self.getCurrentWeatherUseCase = getCurrentWeatherUseCase
        self.getRecentSearchTermsUseCase = getRecentSearchTermsUseCase
        self.saveSearchTermUseCase = saveSearchTermUseCase
    }

    func viewDidLoad() {
        getRecentSearchTerms()
    }

    func onSearchButtonTapped(query: String) {
        view?.display(loading: true)
        saveSearchTerm(query)
        getCurrentWeather(for: query)
    }

    func searchTermTapped(at index: Int) {
        guard let query = currentRecentTerms[safe: index] else { return }

        view?.display(searchQuery: query)
        onSearchButtonTapped(query: query)
    }

    private func getCurrentWeather(for query: String) {
        Task {
            let weather = try? await getCurrentWeatherUseCase.invoke(query: query)

            view?.display(loading: false)
            getRecentSearchTerms()

            if let weather = weather {
                handleSuccessful(weather: weather)
            } else {
                handleWeatherFailure()
            }
        }
    }

    private func handleSuccessful(weather: Weather) {
        let viewModel = CurrentWeatherViewModel(locationName: weather.name,
                                                locationTemperature: weather.temperature,
                                                locationDescription: weather.description)

        router.displayWeatherResults(weatherViewModel: viewModel)
    }

    private func handleWeatherFailure() {
        router.displayError()
    }

    private func getRecentSearchTerms() {
        Task {
            let recentTerms = (try? await getRecentSearchTermsUseCase.invoke()) ?? []
            currentRecentTerms = recentTerms
            view?.display(recentTerms: recentTerms.map { RecentSearchTermViewModel(term: $0) })
        }
    }

    private func saveSearchTerm(_ term: String) {
        Task {
            try? await saveSearchTermUseCase.invoke(term: term)
        }
    }
}
