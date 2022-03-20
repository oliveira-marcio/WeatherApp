import Foundation

protocol URLRequestable {
    var urlRequest: URLRequest { get }
}

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

extension URLSession: URLSessionProtocol { }
