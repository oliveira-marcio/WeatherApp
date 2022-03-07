import Foundation

protocol CurrentWeatherView: AnyObject {
    var presenter: CurrentWeatherPresenter! { get set }
    func display(loading: Bool)
    func display(recentTerms: [RecentSearchTermViewModel])
    func display(searchQuery: String)
}

final class CurrentWeatherPresenter {
    enum LocalizationKeys {
        static let errorTitle = NSLocalizedString("WeatherRequestFailTitle", comment: "")
        static let errorMessage = NSLocalizedString("WeatherRequestFailMessage", comment: "")
        static let errorDismiss = NSLocalizedString("WeatherRequestFailDismiss", comment: "")
        static let resultsTitle = NSLocalizedString("WeatherResultsTitle", comment: "")
        static let resultsTemperatureSuffix = NSLocalizedString("WeatherResultsTemperatureSuffix", comment: "")
        static let resultsDismissLabel = NSLocalizedString("WeatherResultsDismissLabel", comment: "")
    }

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
        saveSearchTerm(query) { [weak self] _ in
            self?.getCurrentWeather(for: query)
        }
    }

    func searchTermTapped(at index: Int) {
        guard let query = currentRecentTerms[safe: index] else { return }

        view?.display(searchQuery: query)
        onSearchButtonTapped(query: query)
    }

    private func getCurrentWeather(for query: String) {
        getCurrentWeatherUseCase.invoke(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.display(loading: false)
                self?.getRecentSearchTerms()

                switch result {
                case let .success(weather):
                    let viewModel = CurrentWeatherViewModel(title: LocalizationKeys.resultsTitle,
                                                            dismissLabel: LocalizationKeys.resultsDismissLabel,
                                                            locationName: weather.name,
                                                            locationTemperature: "\(weather.temperature)\(LocalizationKeys.resultsTemperatureSuffix)",
                                                            locationDescription: weather.description)

                    self?.router.displayWeatherResults(weatherViewModel: viewModel)

                case .failure(_):
                    let viewModel = ErrorViewModel(title: LocalizationKeys.errorTitle,
                                                   message: LocalizationKeys.errorMessage,
                                                   dismiss: LocalizationKeys.errorDismiss)

                    self?.router.displayError(errorViewModel: viewModel)
                }
            }
        }
    }

    private func getRecentSearchTerms() {
        getRecentSearchTermsUseCase.invoke { [weak self] result in
            DispatchQueue.main.async {
                if let recentTerms = try? result.get() {
                    self?.currentRecentTerms = recentTerms
                    self?.view?.display(recentTerms: recentTerms.map { RecentSearchTermViewModel(term: $0) })
                }
            }
        }
    }

    private func saveSearchTerm(_ term: String, completion: @escaping (RecentSearchError?) -> Void) {
        saveSearchTermUseCase.invoke(term: term, completion: completion)
    }
}
