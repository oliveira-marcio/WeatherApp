import Foundation

final class DependencyResolver: DependencyResolvable {
    lazy var requestExecutor: RequestExecutor = RequestExecutorImplementation(urlSession: URLSession.shared)

    lazy var weatherGateway: WeatherGateway = WeatherGatewayImplementation(baseURL: Configuration.baseURL(),
                                                                           apiKey: Configuration.apiKey(),
                                                                           requestExecutor: requestExecutor)

    lazy var recentSearchGateway: RecentSearchGateway = InMemoryRecentSearchGateway()
}
