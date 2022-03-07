import Foundation

final class AppDomain {
    let getCurrentWeatherUseCase: GetCurrentWeatherUseCase
    let getRecentSearchTermsUseCase: GetRecentSearchTermsUseCase
    let saveSearchTermUseCase: SaveSearchTermUseCase

    init(dependencies: DependencyResolvable) {
        getCurrentWeatherUseCase = GetCurrentWeatherUseCaseImplementation(dependencies: dependencies)
        getRecentSearchTermsUseCase = GetRecentSearchTermsUseCaseImplementation(dependencies: dependencies)
        saveSearchTermUseCase = SaveSearchTermUseCaseImplementation(dependencies: dependencies)
    }
}
