import Foundation

struct AppEnvironment {
    let dependencies: DependencyResolver
    let domain: AppDomain

    static func bootstrap() -> AppEnvironment {
        let dependencies = DependencyResolver()
        let domain = AppDomain(dependencies: dependencies)

        return AppEnvironment(dependencies: dependencies, domain: domain)
    }
}
