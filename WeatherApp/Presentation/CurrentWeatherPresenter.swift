import Foundation

protocol CurrentWeatherView: AnyObject {
    var presenter: CurrentWeatherPresenter! { get set }
    func display(loading: Bool)
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

    init(view: CurrentWeatherView,
         router: CurrentWeatherRouter,
         getCurrentWeatherUseCase: GetCurrentWeatherUseCase) {
        self.view = view
        self.router = router
        self.getCurrentWeatherUseCase = getCurrentWeatherUseCase
    }

    func onSearchButtonTapped(query: String) {
        view?.display(loading: true)
        getCurrentWeatherUseCase.invoke(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.display(loading: false)

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
}
