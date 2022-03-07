final class CurrentWeatherViewConfigurator {
    static func configure(view: CurrentWeatherViewController) {
        let getCurrentWeatherUseCase = SceneDelegate.appEnvironment.domain.getCurrentWeatherUseCase
        let getRecentSearchTermsUseCase = SceneDelegate.appEnvironment.domain.getRecentSearchTermsUseCase
        let saveSearchTermUseCase = SceneDelegate.appEnvironment.domain.saveSearchTermUseCase


        let router = CurrentWeatherRouterImplementation(currentWeatherViewController: view)
        let presenter = CurrentWeatherPresenter(view: view,
                                                router: router,
                                                getCurrentWeatherUseCase: getCurrentWeatherUseCase,
                                                getRecentSearchTermsUseCase: getRecentSearchTermsUseCase,
                                                saveSearchTermUseCase: saveSearchTermUseCase)
        view.presenter = presenter
    }
}
