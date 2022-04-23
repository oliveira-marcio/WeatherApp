import Foundation

protocol GetRecentSearchTermsUseCase {
    func invoke() async throws -> [String]
}

protocol GetRecentSearchTermsUseCaseDependenciesResolvable {
    var recentSearchGateway: RecentSearchGateway { get }
}

final class GetRecentSearchTermsUseCaseImplementation: GetRecentSearchTermsUseCase {
    private let recentSearchGateway: RecentSearchGateway

    init(recentSearchGateway: RecentSearchGateway) {
        self.recentSearchGateway = recentSearchGateway
    }

    convenience init(dependencies: GetRecentSearchTermsUseCaseDependenciesResolvable) {
        self.init(recentSearchGateway: dependencies.recentSearchGateway)
    }

    func invoke() async throws -> [String] {
        try await recentSearchGateway.fetchAllTerms()
    }
}
