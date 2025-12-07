import Testing
import Foundation
@testable import WeatherApp

@Suite
struct RequestExecutorTests {
    private let urlSessionStub: URLSessionStub
    private let requestExecutor: RequestExecutorImplementation

    init() {
        urlSessionStub = URLSessionStub()
        requestExecutor = RequestExecutorImplementation(urlSession: urlSessionStub)
    }

    @Test
    func GIVEN_request_WHEN_data_is_valid_THEN_it_should_return_parsed_entity() async {
        let responseData = """
        {"test": "success"}
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        let entity: TestEntity? = try? await requestExecutor.execute(request: Request())

        #expect(entity == TestEntity(test: "success"))
    }

    @Test
    func GIVEN_request_WHEN_there_is_an_error_THEN_it_should_return_api_error() async {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: nil,
                                          error: SomeError.error))

        await #expect(throws: ApiError.operationFailed("error")) {
            try await requestExecutor.execute(request: Request()) as TestEntity
        }
    }

    @Test
    func GIVEN_request_WHEN_there_is_no_response_THEN_it_should_return_api_error() async {
        urlSessionStub.enqueue(response: (data: nil,
                                          response: nil,
                                          error: nil))

        await #expect(throws: ApiError.operationFailed("error")) {
            try await requestExecutor.execute(request: Request()) as TestEntity
        }
    }

    @Test
    func GIVEN_request_WHEN_response_is_not_success_THEN_it_should_return_api_error() async {
        urlSessionStub.enqueue(response: (data: "error".data(using: .utf8),
                                          response: HTTPURLResponse(statusCode: 500),
                                          error: nil))

        await #expect(throws: ApiError.operationFailed("500")) {
            try await requestExecutor.execute(request: Request()) as TestEntity
        }
    }

    @Test
    func GIVEN_request_WHEN_response_is_success_and_data_is_invalid_THEN_it_should_return_parse_error() async {
        let responseData = """
        {"invalid": "failure"}
        """.data(using: .utf8)

        urlSessionStub.enqueue(response: (data: responseData,
                                          response: HTTPURLResponse(statusCode: 200),
                                          error: nil))

        await #expect(throws: ApiError.parseError("The data couldn’t be read because it is missing.")) {
            try await requestExecutor.execute(request: Request()) as TestEntity
        }
    }

    enum SomeError: Error, LocalizedError {
        case error

        var errorDescription: String? { "error".localized() }
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
