import Foundation

protocol SaveSearchTermUseCase {
    func invoke(term: String, completion: @escaping (RecentSearchError?) -> Void)
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

    func invoke(term: String, completion: @escaping (RecentSearchError?) -> Void) {
        recentSearchGateway.insert(term: term, completion: completion)
    }
}
