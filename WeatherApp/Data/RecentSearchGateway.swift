import Foundation

enum RecentSearchError: Error {
    case unableToFetch
    case unableToInsert
}

protocol RecentSearchGateway {
    func fetchAllTerms() async throws -> [String]
    func insert(term: String) async throws
}

/**
 * In-memory Database to mock a real one with a background queue and flags to simulate
 * errors for testing purposes
 */

final class InMemoryRecentSearchGateway: RecentSearchGateway {
    private var mapTerms = [String: (String, Int)]()
    private var termIndex = 0

    var fetchShouldFail = false
    var insertShouldFail = false

    func fetchAllTerms() async throws -> [String] {
        if fetchShouldFail {
            throw RecentSearchError.unableToFetch
        } else {
            // terms by indexes in reverse order
            return mapTerms
                .sorted { $0.1.1 > $1.1.1 }
                .map { $0.1.0 }
        }
    }

    func insert(term: String) async throws {
        if insertShouldFail {
            throw RecentSearchError.unableToInsert
        } else {
            mapTerms[term.lowercased()] = (term, termIndex)
            termIndex += 1
        }
    }
}
