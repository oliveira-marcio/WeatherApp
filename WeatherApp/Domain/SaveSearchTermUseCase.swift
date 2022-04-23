import Foundation

protocol SaveSearchTermUseCase {
    func invoke(term: String) async throws
}

protocol SaveSearchTermUseCaseDependenciesResolvable {
    var recentSearchGateway: RecentSearchGateway { get }
}

final class SaveSearchTermUseCaseImplementation: SaveSearchTermUseCase {
    private let recentSearchGateway: RecentSearchGateway

    init(recentSearchGateway: RecentSearchGateway) {
        self.recentSearchGateway = recentSearchGateway
    }

    convenience init(dependencies: SaveSearchTermUseCaseDependenciesResolvable) {
        self.init(recentSearchGateway: dependencies.recentSearchGateway)
    }

    func invoke(term: String) async throws {
        try await recentSearchGateway.insert(term: term)
    }
}
