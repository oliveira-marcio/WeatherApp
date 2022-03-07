import XCTest
@testable import WeatherApp

final class RequestExecutorTests: XCTestCase {
    private var urlSessionStub: URLSessionStub!
    private var requestExecutor: RequestExecutorImplementation!

    override func setUp() {
        super.setUp()
        urlSessionStub = URLSessionStub()
        requestExecutor = RequestExecutorImplementation(urlSession: urlSessionStub)
    }

    override func tearDown() {
        super.tearDown()
        requestExecutor = nil
        urlSessionStub = nil
    }

    func test_GIVEN_request_WHEN_data_is_valid_THEN_it_should_return_parsed_entity() {
        let responseData = """
        {"test": "success"}
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        let requestExpectation = expectation(description: "request expectation")
        var entity: TestEntity?

        requestExecutor.execute(request: Request()) { (result: Result<TestEntity, ApiError>) in
            entity = try? result.get()
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(entity, TestEntity(test: "success"))
    }

    func test_GIVEN_request_WHEN_there_is_an_error_THEN_it_should_return_api_error() {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: nil,
                                          error: SomeError.error))

        let requestExpectation = expectation(description: "request expectation")
        var error: ApiError?

        requestExecutor.execute(request: Request()) { (result: Result<TestEntity, ApiError>) in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(error, .operationFailed("error"))
    }

    func test_GIVEN_request_WHEN_there_is_no_response_THEN_it_should_return_api_error() {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: nil,
                                          error: nil))

        let requestExpectation = expectation(description: "request expectation")
        var error: ApiError?

        requestExecutor.execute(request: Request()) { (result: Result<TestEntity, ApiError>) in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(error, .operationFailed("No response"))
    }

    func test_GIVEN_request_WHEN_response_is_not_success_THEN_it_should_return_api_error() {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: HTTPURLResponse(statusCode: 500),
                                          error: nil))

        let requestExpectation = expectation(description: "request expectation")
        var error: ApiError?

        requestExecutor.execute(request: Request()) { (result: Result<TestEntity, ApiError>) in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(error, .operationFailed("500"))
    }

    func test_GIVEN_request_WHEN_response_is_success_and_there_is_no_data_THEN_it_should_return_api_error() {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        let requestExpectation = expectation(description: "request expectation")
        var error: ApiError?

        requestExecutor.execute(request: Request()) { (result: Result<TestEntity, ApiError>) in
            if case let .failure(errorResult) = result {
                error = errorResult
            }
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertEqual(error, .operationFailed("No body"))
    }

    func test_GIVEN_request_WHEN_response_is_success_and_data_is_invalid_THEN_it_should_return_parse_error() {
        let responseData = """
        {"invalid": "failure"}
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        let requestExpectation = expectation(description: "request expectation")
        var parseError = false

        requestExecutor.execute(request: Request()) { (result: Result<TestEntity, ApiError>) in
            if case let .failure(errorResult) = result,
                case .parseError(_) = errorResult {
                parseError = true
            }
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertTrue(parseError)
    }

    enum SomeError: Error, LocalizedError {
        case error

        var errorDescription: String? { NSLocalizedString("error", comment: "") }
    }

    struct Request: URLRequestable {
        var urlRequest: URLRequest {
            var request = URLRequest(url: URL(string: "https://www.foo.com")!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }
    }

    struct TestEntity: Decodable, Equatable {
        let test: String

        init(test: String) {
            self.test = test
        }
    }
}
