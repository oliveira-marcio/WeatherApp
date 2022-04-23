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
        CurrentWeatherViewModel(locationName: weather.name,
                                locationTemperature: weather.temperature,
                                locationDescription: weather.description)
    }
}

extension RecentSearchTermViewModel {
    static func stubList(from terms: [String]) -> [RecentSearchTermViewModel] {
        terms.map { RecentSearchTermViewModel(term: $0)}
    }
}
