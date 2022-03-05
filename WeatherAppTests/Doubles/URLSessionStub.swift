import Foundation
@testable import WeatherApp

public final class URLSessionStub: URLSessionProtocol {
    public typealias URLSessionCompletionHandlerResponse = (data: Data?, response: URLResponse?, error: Error?)

    var responses = [URLSessionCompletionHandlerResponse]()

    public init() {}

    public func enqueue(response: URLSessionCompletionHandlerResponse) {
        responses.append(response)
    }

    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let firstResponse = responses.first else {
            return StubTask(response: nil, completionHandler: completionHandler)
        }

        responses.removeFirst()
        return StubTask(response: firstResponse, completionHandler: completionHandler)
    }

    private class StubTask: URLSessionDataTask {
        let testDoubleResponse: URLSessionCompletionHandlerResponse?
        let completionHandler: (Data?, URLResponse?, Error?) -> Void

        init(response: URLSessionCompletionHandlerResponse?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            self.testDoubleResponse = response
            self.completionHandler = completionHandler
        }

        override public func resume() {
            completionHandler(testDoubleResponse?.data, testDoubleResponse?.response, testDoubleResponse?.error)
        }
    }
}

public extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "https://www.foo.com")!,
                  statusCode: statusCode,
                  httpVersion: nil,
                  headerFields: nil)!
    }
}
