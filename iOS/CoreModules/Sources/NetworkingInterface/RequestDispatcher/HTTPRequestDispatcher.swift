import Foundation
import Combine

public protocol HTTPRequestDispatcherProtocol {
    func executeRequest(_ request: URLRequestProtocol) -> AnyPublisher<Data, HTTPRequestError>
}
