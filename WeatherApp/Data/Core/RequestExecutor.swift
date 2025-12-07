import Foundation

protocol RequestExecutor {
    func execute<T>(request: URLRequestable) async throws -> T where T: Decodable
}

enum ApiError: Error, Equatable {
    case operationFailed(String)
    case parseError(String)
}

final class RequestExecutorImplementation: RequestExecutor {
    private let urlSession: URLSessionProtocol

    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func execute<T>(request: URLRequestable) async throws -> T where T: Decodable {
        let (data, response) = try await urlSession.data(for: request.urlRequest)

        // Check if we have a `HTTPURLResponse`
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.operationFailed("No response")
        }

        // Check if response is a success (ignore data if it fails)
        guard httpResponse.type == .success else {
            throw ApiError.operationFailed("\(httpResponse.statusCode)")
        }

        // Parse data
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .iso8601

            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw ApiError.parseError(error.localizedDescription)
        }
    }
}

enum ResponseType {
    case success
    case unAuthorized
    case forbidden
    case error
    case other
}

extension HTTPURLResponse {

    var isSuccess: Bool {
        return (200...299).contains(statusCode)
    }

    var isUnauthorized: Bool {
        return statusCode == 401
    }

    var isNotFound: Bool {
        return statusCode == 404
    }

    var isForbidden: Bool {
        return statusCode == 403
    }

    var isServerError: Bool {
        return (500..<600).contains(statusCode)
    }

    var type: ResponseType {
        if isSuccess { return .success }
        if isUnauthorized { return .unAuthorized }
        if isForbidden { return .forbidden }
        if isServerError { return .error }
        return .other
    }
}
