import Combine
import Foundation
import NetworkingInterface

public typealias ProductRepositoryError = APIError

public protocol ProductRepositoryProtocol {
    func getAll() -> AnyPublisher<[Product], ProductRepositoryError>
    func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductRepositoryError>
}
