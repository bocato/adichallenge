import Combine
import Foundation
import NetworkingInterface

// TODO: Handle Reachability
public final class HTTPRequestDispatcher: HTTPRequestDispatcherProtocol {
    // MARK: - Dependencies

    private let session: URLSessionProtocol
    private let jsonSerializer: JSONSerialization.Type

    // MARK: - Initialization

    init(
        session: URLSessionProtocol,
        jsonSerializer: JSONSerialization.Type
    ) {
        self.session = session
        self.jsonSerializer = jsonSerializer
    }

    public convenience init() {
        self.init(
            session: URLSession.shared,
            jsonSerializer: JSONSerialization.self
        )
    }

    // MARK: - Public API

    public func executeRequest(_ request: URLRequestProtocol) -> AnyPublisher<Data, HTTPRequestError> {
        do {
            let urlRequest = try request.mapToURLRequest(using: jsonSerializer)
            return session
                .dataTaskPublisher(for: urlRequest)
                .tryMap { data, response in
                    guard
                        let httpStatusCode = (response as? HTTPURLResponse)?.statusCode
                    else { throw HTTPRequestError.invalidHTTPResponse }
                    guard 200 ... 299 ~= httpStatusCode else {
                        throw self.parseError(with: data, code: httpStatusCode)
                    }
                    return data
                }.mapError { networkingError in
                    guard !networkingError.isNetworkConnectionError else {
                        return .unreachableNetwork
                    }
                    return .networking(networkingError)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail<Data, HTTPRequestError>(error: .requestDataSerialization(error))
                .eraseToAnyPublisher()
        }
    }

    private func parseError(with data: Data, code: Int) -> HTTPRequestError {
        guard
            let dictionary = try? jsonSerializer.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { return .unexpectedAPIError }
        let error: NSError = .init(domain: "Networking", code: code, userInfo: dictionary)
        return .apiError(.init(rawError: error))
    }
}
