import Foundation
@testable import WeatherApp

final class MockRecentSearchGateway: RecentSearchGateway {
    var fetchAllTermsDelay: Double
    var fetchAllTermsQueue = MockResultQueue<[String], RecentSearchError>()

    var insertTermDelay: Double
    var insertTermQueue = MockErrorQueue<RecentSearchError>()
    var term: String?

    init() {
        fetchAllTermsDelay = 0
        insertTermDelay = 0

        fetchAllTermsQueue.set(.success(["New York", "Lisbon", "Rio de Janeiro"]))
        insertTermQueue.set(nil)
    }

    func fetchAllTerms() async throws -> [String] {
        try await Task.sleep(nanoseconds: UInt64(fetchAllTermsDelay * Double(NSEC_PER_SEC)))
        switch fetchAllTermsQueue.dequeue() {
        case let .success(terms): return terms
        case let .failure(error): throw error
        }
    }

    func insert(term: String) async throws {
        self.term = term
        try await Task.sleep(nanoseconds: UInt64(insertTermDelay * Double(NSEC_PER_SEC)))
        guard let error = insertTermQueue.dequeue() else { return }
        throw error
    }
}
