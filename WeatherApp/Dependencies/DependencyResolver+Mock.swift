import Foundation

final class DependencyResolver: DependencyResolvable {
    var test = "test mock"

    lazy var weatherGateway: WeatherGateway = MockWeatherGateway()
}
