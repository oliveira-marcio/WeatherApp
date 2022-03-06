import XCTest
@testable import WeatherApp

final class RecentSearchGatewayTests: XCTestCase {
    var gateway: InMemoryRecentSearchGateway!

    override func setUp() {
        super.setUp()
        gateway = InMemoryRecentSearchGateway()
    }

    override func tearDown() {
        super.tearDown()
        gateway = nil
    }

    func test_GIVEN_no_entries_stored_WHEN_fetchAllTerms_is_called_THEN_it_should_return_empty() {
        var actualTerms: [String]?
        let fetchExpectation = expectation(description: "fetch all expectation")

        gateway.fetchAllTerms { result in
            actualTerms = try? result.get()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(actualTerms, [])
    }

    func test_GIVEN_entries_stored_WHEN_fetchAllTerms_is_called_THEN_it_should_return_all_entries() {
        let expectedTerms = populateSampleData(values: 5)

        var actualTerms: [String]?
        let fetchExpectation = expectation(description: "fetch all expectation")

        gateway.fetchAllTerms { result in
            actualTerms = try? result.get()
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(actualTerms, expectedTerms)
    }

    func test_GIVEN_entries_stored_WHEN_fetchAllTerms_is_called_and_gateway_fails_THEN_it_should_return_fetch_error() {
        let _ = populateSampleData(values: 5)
        gateway.fetchShouldFail = true

        var error: RecentSearchError?
        let fetchExpectation = expectation(description: "fetch all expectation")

        gateway.fetchAllTerms { result in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(error, .unableToFetch)
    }

    func test_GIVEN_entries_stored_WHEN_term_is_inserted_THEN_fetchAllTerms_should_return_updated_entries_with_inserted_one_at_first() {
        let expectedTerms = ["Term 6"] + populateSampleData(values: 5)

        var actualTerms: [String]?
        let fetchExpectation = expectation(description: "insert and fetch all expectation")

        gateway.insert(term: "Term 6") { [weak self] _ in
            self?.gateway.fetchAllTerms { result in
                actualTerms = try? result.get()
                fetchExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(actualTerms, expectedTerms)
    }

    func test_GIVEN_entries_stored_WHEN_existing_term_even_in_different_case_is_inserted_THEN_it_should_not_be_inserted_again_and_fetchAllTerms_should_return_updated_entries_with_attempted_term_at_first() {
        let _ = populateSampleData(values: 3)
        let expectedTerms = ["teRM 2", "Term 3", "Term 1"]

        var actualTerms: [String]?
        let fetchExpectation = expectation(description: "insert and fetch all expectation")

        gateway.insert(term: "teRM 2") { [weak self] _ in
            self?.gateway.fetchAllTerms { result in
                actualTerms = try? result.get()
                fetchExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(actualTerms, expectedTerms)
    }

    func test_GIVEN_entries_stored_WHEN_term_is_inserted_THEN_it_should_return_insert_error() {
        let _ = populateSampleData(values: 3)
        gateway.insertShouldFail = true

        var error: RecentSearchError?
        let fetchExpectation = expectation(description: "insert and fetch all expectation")

        gateway.insert(term: "Term 4") { errorResult in
            error = errorResult
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(error, .unableToInsert)
    }

    private func populateSampleData(values: Int) -> [String] {
        var terms = [String]()
        for i in (1...values) {
            let termToInsertInDB = "Term \(i)"
            let termToInsertInSample = "Term \(values - i + 1)"
            terms.append(termToInsertInSample)
            gateway.insert(term: termToInsertInDB) { _ in }
        }

        return terms
    }
}
