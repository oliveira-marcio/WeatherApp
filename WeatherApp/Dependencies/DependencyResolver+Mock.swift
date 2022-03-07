import Foundation

final class DependencyResolver: DependencyResolvable {
    lazy var weatherGateway: WeatherGateway = MockWeatherGateway()
    lazy var recentSearchGateway: RecentSearchGateway = MockRecentSearchGateway()

    init() {
        let env = ProcessInfo.processInfo.environment

        env.keys.forEach { envKey in
            guard let key = LaunchEnvironmentKey(rawValue: envKey) else { return }

            switch key {
            case .withCurrentWeather:
                if let weatherGateway = weatherGateway as? MockWeatherGateway {
                    weatherGateway.fetchCurrentWeatherDelay = 0
                    weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))
                }

                if let recentSearchGateway = recentSearchGateway as? MockRecentSearchGateway {
                    recentSearchGateway.fetchAllTermsDelay = 0
                    let recentTerms = ["Lisbon", "Rio de Janeiro"]
                    let refreshedRecentTerms = ["New York", "Lisbon", "Rio de Janeiro"]
                    recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms), .success(refreshedRecentTerms))
                }

            case .withCurrentWeatherError:
                if let weatherGateway = weatherGateway as? MockWeatherGateway {
                    weatherGateway.fetchCurrentWeatherDelay = 0
                    weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))
                }

            case .withLoadingCurrentWeather:
                if let weatherGateway = weatherGateway as? MockWeatherGateway {
                    weatherGateway.fetchCurrentWeatherDelay = 3
                    weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))
                }

            case .withLoadingCurrentWeatherError:
                if let weatherGateway = weatherGateway as? MockWeatherGateway {
                    weatherGateway.fetchCurrentWeatherDelay = 3
                    weatherGateway.fetchCurrentWeatherQueue.set(.failure(.operationFailed))
                }
                
            case .withRecentSearchTerms:
                if let recentSearchGateway = recentSearchGateway as? MockRecentSearchGateway {
                    recentSearchGateway.fetchAllTermsDelay = 0
                    let recentTerms = ["New York", "Lisbon", "Rio de Janeiro"]
                    recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms))
                }

            case .withTappedRecentSearchTerm:
                if let weatherGateway = weatherGateway as? MockWeatherGateway {
                    weatherGateway.fetchCurrentWeatherDelay = 0
                    weatherGateway.fetchCurrentWeatherQueue.set(.success(.nyDummy))
                }

                if let recentSearchGateway = recentSearchGateway as? MockRecentSearchGateway {
                    recentSearchGateway.fetchAllTermsDelay = 0
                    let recentTerms = ["Lisbon", "Rio de Janeiro", "New York"]
                    let refreshedRecentTerms = ["New York", "Lisbon", "Rio de Janeiro"]
                    recentSearchGateway.fetchAllTermsQueue.set(.success(recentTerms), .success(refreshedRecentTerms))
                }
            }
        }
    }
}
