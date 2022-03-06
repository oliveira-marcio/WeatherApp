import Foundation

final class DependencyResolver: DependencyResolvable {
    var test = "test normal"

    lazy var requestExecutor: RequestExecutor = RequestExecutorImplementation(urlSession: URLSession.shared)

    lazy var weatherGateway: WeatherGateway = WeatherGatewayImplementation(baseURL: Configuration.baseURL(),
                                                                           apiKey: Configuration.apiKey(),
                                                                           requestExecutor: requestExecutor)
}
