import Combine
import Foundation

public protocol HTTPRequestDispatcherProtocol {
    func executeRequest(_ request: URLRequestProtocol) -> AnyPublisher<Data, HTTPRequestError>
}
