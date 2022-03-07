import Foundation
@testable import WeatherApp

final class MockRecentSearchGateway: RecentSearchGateway {
    private var queue = DispatchQueue(label: "com.marcio.WeatherApp.MockRecentSearchGateway")

    var fetchAllTermsDelay: Int
    var fetchAllTermsQueue = MockResultQueue<[String], RecentSearchError>()

    var insertTermDelay: Int
    var insertTermQueue = MockErrorQueue<RecentSearchError>()
    var term: String?

    init() {
        fetchAllTermsDelay = 0
        insertTermDelay = 0

        fetchAllTermsQueue.set(.success(["New York", "Lisbon", "Rio de Janeiro"]))
        insertTermQueue.set(nil)
    }

    func fetchAllTerms(completion: @escaping (Result<[String], RecentSearchError>) -> Void) {
        queue.asyncAfter(deadline: .now() + .seconds(fetchAllTermsDelay)) { [unowned self] in
            completion(self.fetchAllTermsQueue.dequeue())
        }
    }

    func insert(term: String, completion: @escaping (RecentSearchError?) -> Void) {
        self.term = term
        queue.asyncAfter(deadline: .now() + .seconds(insertTermDelay)) { [unowned self] in
            completion(self.insertTermQueue.dequeue())
        }
    }
}
