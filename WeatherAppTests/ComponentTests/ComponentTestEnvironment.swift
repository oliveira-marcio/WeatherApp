import Foundation
@testable import WeatherApp

struct ComponentTestEnvironment {
    let data: ComponentData
    let presentation: ComponentPresentation

    static func bootstrap() -> ComponentTestEnvironment {
        let data = ComponentData()
        let domain = AppDomain(dependencies: data)
        let presentation = ComponentPresentation(domain: domain)

        return ComponentTestEnvironment(data: data, presentation: presentation)
    }
}

final class ComponentData: DependencyResolvable {
    lazy var weatherGateway: WeatherGateway = MockWeatherGateway()
    lazy var recentSearchGateway: RecentSearchGateway = MockRecentSearchGateway()
}

final class ComponentPresentation {
    private let domain: AppDomain

    init(domain: AppDomain) {
        self.domain = domain
    }

    lazy var currentWeatherView = CurrentWeatherViewSpy()
    lazy var currentWeatherRouter = CurrentWeatherRouterSpy()

    lazy var currentWeatherPresenter = CurrentWeatherPresenter(view: currentWeatherView,
                                                               router: currentWeatherRouter,
                                                               getCurrentWeatherUseCase: domain.getCurrentWeatherUseCase,
                                                               getRecentSearchTermsUseCase: domain.getRecentSearchTermsUseCase,
                                                               saveSearchTermUseCase: domain.saveSearchTermUseCase)
}
