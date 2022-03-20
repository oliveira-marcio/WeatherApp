import Foundation
@testable import WeatherApp

final class RequestExecutorSpy: RequestExecutor {
    var request: URLRequestable?

    func execute<T>(request: URLRequestable) async throws -> T where T: Decodable {
        self.request = request
        throw ApiError.operationFailed("error")
    }
}
