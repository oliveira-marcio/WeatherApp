import Foundation

final class DependencyResolver: DependencyResolvable {
    lazy var weatherGateway: WeatherGateway = MockWeatherGateway()
    lazy var recentSearchGateway: RecentSearchGateway = MockRecentSearchGateway()
}
