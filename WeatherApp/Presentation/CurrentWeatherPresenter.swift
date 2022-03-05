import Foundation

protocol CurrentWeatherView: AnyObject {
    var presenter: CurrentWeatherPresenter! { get set }
    func display(weather: Weather)
    func display(loading: Bool)
    func display(title: String, error: String)
}

final class CurrentWeatherPresenter {
    enum LocalizationKeys {
        static let errorTitle = NSLocalizedString("WeatherRequestFailTitle", comment: "")
        static let errorMessage = NSLocalizedString("WeatherRequestFailMessage", comment: "")
    }

    private weak var view: CurrentWeatherView?
    private let getCurrentWeatherUseCase: GetCurrentWeatherUseCase

    init(view: CurrentWeatherView,
         getCurrentWeatherUseCase: GetCurrentWeatherUseCase) {
        self.view = view
        self.getCurrentWeatherUseCase = getCurrentWeatherUseCase
    }

    func onSearchButtonTapped(query: String) {
        view?.display(loading: true)
        getCurrentWeatherUseCase.invoke(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.display(loading: false)

                switch result {
                case let .success(weather):
                    self?.view?.display(weather: weather)

                case .failure(_):
                    self?.view?.display(title: LocalizationKeys.errorTitle, error: LocalizationKeys.errorMessage)
                }
            }
        }
    }
}
