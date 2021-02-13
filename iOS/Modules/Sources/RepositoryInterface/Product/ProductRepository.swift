import Combine
import Foundation
import NetworkingInterface

public typealias ProductRepositoryError = APIError

public protocol ProductRepositoryProtocol {
    func getAll() -> AnyPublisher<[Product], ProductRepositoryError>
    func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductRepositoryError>
}

#if DEBUG
public final class ProductRepositoryDummy: ProductRepositoryProtocol {
    public init() {}
    
    public func getAll() -> AnyPublisher<[Product], ProductRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
    
    public func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ProductRepositoryStub: ProductRepositoryProtocol {
    public init() {}
    
    public var getAllResultToBeReturned: Result<[Product], ProductRepositoryError> = .success([])
    public func getAll() -> AnyPublisher<[Product], ProductRepositoryError> {
        getAllResultToBeReturned.publisher.eraseToAnyPublisher()
    }
    
    public var getProductWithIDResultToBeReturned: Result<Product, ProductRepositoryError> = .success(.fixture())
    public func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductRepositoryError> {
        getProductWithIDResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}
#endif
