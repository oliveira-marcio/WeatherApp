final class CurrentWeatherViewConfigurator {
    static func configure(view: CurrentWeatherViewController) {
        let getCurrentWeatherUseCase = SceneDelegate.appEnvironment.domain.getCurrentWeatherUseCase
        let router = CurrentWeatherRouterImplementation(currentWeatherViewController: view)
        let presenter = CurrentWeatherPresenter(view: view,
                                                router: router,
                                                getCurrentWeatherUseCase: getCurrentWeatherUseCase)
        view.presenter = presenter
    }
}
