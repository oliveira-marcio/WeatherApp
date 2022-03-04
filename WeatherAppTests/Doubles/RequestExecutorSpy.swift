import Foundation
@testable import WeatherApp

final class RequestExecutorSpy: RequestExecutor {
    var request: URLRequestable?

    func execute<T>(request: URLRequestable, completion: @escaping (Result<T, ApiError>) -> Void) where T : Decodable {
        self.request = request
    }
}
