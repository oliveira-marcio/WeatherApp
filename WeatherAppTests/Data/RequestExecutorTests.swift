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

    func test_GIVEN_request_WHEN_data_is_valid_THEN_it_should_return_parsed_entity() async {
        let responseData = """
        {"test": "success"}
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        let entity: TestEntity? = try? await requestExecutor.execute(request: Request())

        XCTAssertEqual(entity, TestEntity(test: "success"))
    }

    func test_GIVEN_request_WHEN_there_is_an_error_THEN_it_should_return_api_error() async {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: nil,
                                          error: SomeError.error))

        var errorResult: ApiError?

        do {
            _ = try await requestExecutor.execute(request: Request()) as TestEntity
        } catch {
            errorResult = error as? ApiError
        }

        XCTAssertEqual(errorResult, .operationFailed("error"))
    }

    func test_GIVEN_request_WHEN_there_is_no_response_THEN_it_should_return_api_error() async {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: nil,
                                          error: nil))

        var errorResult: ApiError?

        do {
            _ = try await requestExecutor.execute(request: Request()) as TestEntity
        } catch {
            errorResult = error as? ApiError
        }

        XCTAssertEqual(errorResult, .operationFailed("error"))
    }

    func test_GIVEN_request_WHEN_response_is_not_success_THEN_it_should_return_api_error() async {
        urlSessionStub.enqueue(response: (data: "error".data(using: .utf8),
                                          response: HTTPURLResponse(statusCode: 500),
                                          error: nil))

        var errorResult: ApiError?

        do {
            _ = try await requestExecutor.execute(request: Request()) as TestEntity
        } catch {
            errorResult = error as? ApiError
        }

        XCTAssertEqual(errorResult, .operationFailed("500"))
    }

    func test_GIVEN_request_WHEN_response_is_success_and_data_is_invalid_THEN_it_should_return_parse_error() async {
        let responseData = """
        {"invalid": "failure"}
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        var parseError = false

        do {
            _ = try await requestExecutor.execute(request: Request()) as TestEntity
        } catch {
            if case .parseError(_) = error as? ApiError {
                parseError = true
            }
        }

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
