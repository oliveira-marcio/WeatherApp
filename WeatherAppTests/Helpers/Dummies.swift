@testable import WeatherApp

extension Weather {
    static let nyDummy = Weather(name: "New York, United States of America",
                                 temperature: 4,
                                 description: "Partly cloudy")

    static let rjDummy = Weather(name: "Rio de Janeiro, Brazil",
                                 temperature: 40,
                                 description: "Sunny")
}

extension CurrentWeatherViewModel {
    static func stub(from weather: Weather) -> CurrentWeatherViewModel {
        CurrentWeatherViewModel(title: CurrentWeatherPresenter.LocalizationKeys.resultsTitle,
                                dismissLabel: CurrentWeatherPresenter.LocalizationKeys.resultsDismissLabel,
                                locationName: weather.name,
                                locationTemperature: "\(weather.temperature)\(CurrentWeatherPresenter.LocalizationKeys.resultsTemperatureSuffix)",
                                locationDescription: weather.description)
    }
}

extension ErrorViewModel {
    static let dummy = ErrorViewModel(title: CurrentWeatherPresenter.LocalizationKeys.errorTitle,
                                      message: CurrentWeatherPresenter.LocalizationKeys.errorMessage,
                                      dismiss: CurrentWeatherPresenter.LocalizationKeys.errorDismiss)
}

extension RecentSearchTermViewModel {
    static func stubList(from terms: [String]) -> [RecentSearchTermViewModel] {
        terms.map { RecentSearchTermViewModel(term: $0)}
    }
}
