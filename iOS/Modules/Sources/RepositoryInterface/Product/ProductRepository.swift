import Foundation
import Combine
import NetworkingInterface

public typealias ProductRepositoryError = APIError

public protocol ProductRepositoryProtocol {
    func getAll() -> AnyPublisher<[Product], ProductRepositoryError>
    func getProductWithID(_ id: Int) -> AnyPublisher<ProductComplete, ProductRepositoryError>
}
