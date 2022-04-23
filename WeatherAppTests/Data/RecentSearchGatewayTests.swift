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

    func test_GIVEN_no_entries_stored_WHEN_fetchAllTerms_is_called_THEN_it_should_return_empty() async {
        let actualTerms = try? await gateway.fetchAllTerms()

        XCTAssertEqual(actualTerms, [])
    }

    func test_GIVEN_entries_stored_WHEN_fetchAllTerms_is_called_THEN_it_should_return_all_entries() async {
        let expectedTerms = await populateSampleData(values: 5)

        let actualTerms = try? await gateway.fetchAllTerms()

        XCTAssertEqual(actualTerms, expectedTerms)
    }

    func test_GIVEN_entries_stored_WHEN_fetchAllTerms_is_called_and_gateway_fails_THEN_it_should_return_fetch_error() async {
        await populateSampleData(values: 5)
        gateway.fetchShouldFail = true

        var errorResult: RecentSearchError?

        do {
            _ = try await gateway.fetchAllTerms()
        } catch {
            errorResult = error as? RecentSearchError
        }

        XCTAssertEqual(errorResult, .unableToFetch)
    }

    func test_GIVEN_entries_stored_WHEN_term_is_inserted_THEN_fetchAllTerms_should_return_updated_entries_with_inserted_one_at_first() async {
        let expectedTerms = await ["Term 6"] + populateSampleData(values: 5)

        try? await gateway.insert(term: "Term 6")
        let actualTerms = try? await gateway.fetchAllTerms()

        XCTAssertEqual(actualTerms, expectedTerms)
    }

    func test_GIVEN_entries_stored_WHEN_existing_term_even_in_different_case_is_inserted_THEN_it_should_not_be_inserted_again_and_fetchAllTerms_should_return_updated_entries_with_attempted_term_at_first() async {
        await populateSampleData(values: 3)
        let expectedTerms = ["teRM 2", "Term 3", "Term 1"]

        try? await gateway.insert(term: "teRM 2")
        let actualTerms = try? await gateway.fetchAllTerms()

        XCTAssertEqual(actualTerms, expectedTerms)
    }

    func test_GIVEN_entries_stored_WHEN_term_is_inserted_THEN_it_should_return_insert_error() async {
        await populateSampleData(values: 3)
        gateway.insertShouldFail = true

        var errorResult: RecentSearchError?

        do {
            _ = try await gateway.insert(term: "Term 4")
        } catch {
            errorResult = error as? RecentSearchError
        }

        XCTAssertEqual(errorResult, .unableToInsert)
    }

    @discardableResult
    private func populateSampleData(values: Int) async -> [String] {
        var terms = [String]()
        for i in (1...values) {
            let termToInsertInDB = "Term \(i)"
            let termToInsertInSample = "Term \(values - i + 1)"
            terms.append(termToInsertInSample)
            try? await gateway.insert(term: termToInsertInDB)
        }

        return terms
    }
}
