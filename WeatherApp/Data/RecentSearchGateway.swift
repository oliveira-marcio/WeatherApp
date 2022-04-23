import Foundation

enum RecentSearchError: Error {
    case unableToFetch
    case unableToInsert
}

protocol RecentSearchGateway {
    func fetchAllTerms(completion: @escaping (Result<[String], RecentSearchError>) -> Void)
    func insert(term: String, completion: @escaping (RecentSearchError?) -> Void)
    func fetchAllTerms() async throws -> [String]
    func insert(term: String) async throws
}

/**
 * In-memory Database to mock a real one with a background queue and flags to simulate
 * errors for testing purposes
 */

final class InMemoryRecentSearchGateway: RecentSearchGateway {
    private var queue = DispatchQueue(label: "com.marcio.WeatherApp.InMemoryRecentSearchGateway")
    private var mapTerms = [String: (String, Int)]()
    private var termIndex = 0

    var fetchShouldFail = false
    var insertShouldFail = false

    func fetchAllTerms(completion: @escaping (Result<[String], RecentSearchError>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.unableToFetch))
                return
            }

            if self.fetchShouldFail {
                completion(.failure(.unableToFetch))
            } else {
                // terms by indexes in reverse order
                let terms = self.mapTerms
                    .sorted { $0.1.1 > $1.1.1 }
                    .map { $0.1.0 }
                completion(.success(terms))
            }
        }
    }

    func insert(term: String, completion: @escaping (RecentSearchError?) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.unableToInsert)
                return
            }

            if self.insertShouldFail {
                completion(.unableToInsert)
            } else {
                self.mapTerms[term.lowercased()] = (term, self.termIndex)
                self.termIndex += 1
                completion(nil)
            }
        }
    }

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
