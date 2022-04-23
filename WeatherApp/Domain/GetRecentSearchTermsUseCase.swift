import Foundation

protocol GetRecentSearchTermsUseCase {
    func invoke(completion: @escaping (Result<[String], RecentSearchError>) -> Void)
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

    func invoke(completion: @escaping (Result<[String], RecentSearchError>) -> Void) {
        recentSearchGateway.fetchAllTerms { result in
            switch result {
            case let .success(terms): completion(.success(terms))
            case let .failure(error): completion(.failure(error))
            }
        }
    }

    func invoke() async throws -> [String] {
        try await recentSearchGateway.fetchAllTerms()
    }
}
