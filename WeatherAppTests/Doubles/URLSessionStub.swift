import Foundation
@testable import WeatherApp

final class URLSessionStub: URLSessionProtocol {
    typealias URLSessionCompletionHandlerResponse = (data: Data?, response: URLResponse?, error: Error?)

    var responses = [URLSessionCompletionHandlerResponse]()

    init() {}

    func enqueue(response: URLSessionCompletionHandlerResponse) {
        responses.append(response)
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
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

        override func resume() {
            completionHandler(testDoubleResponse?.data, testDoubleResponse?.response, testDoubleResponse?.error)
        }
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "https://www.foo.com")!,
                  statusCode: statusCode,
                  httpVersion: nil,
                  headerFields: nil)!
    }
}
