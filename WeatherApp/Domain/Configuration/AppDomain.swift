import Foundation

final class AppDomain {
    let getCurrentWeatherUseCase: GetCurrentWeatherUseCase

    init(dependencies: DependencyResolvable) {
        getCurrentWeatherUseCase = GetCurrentWeatherUseCaseImplementation(dependencies: dependencies)
    }
}
