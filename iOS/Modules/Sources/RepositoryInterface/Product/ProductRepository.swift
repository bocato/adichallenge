import Combine
import Foundation
import NetworkingInterface

public typealias ProductsRepositoryError = APIError

public protocol ProductsRepositoryProtocol {
    func getAll() -> AnyPublisher<[Product], ProductsRepositoryError>
    func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductsRepositoryError>
}

#if DEBUG
public final class ProductsRepositoryDummy: ProductsRepositoryProtocol {
    public init() {}
    
    public func getAll() -> AnyPublisher<[Product], ProductsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
    
    public func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ProductsRepositoryStub: ProductsRepositoryProtocol {
    public init() {}
    
    public var getAllResultToBeReturned: Result<[Product], ProductsRepositoryError> = .success([])
    public func getAll() -> AnyPublisher<[Product], ProductsRepositoryError> {
        getAllResultToBeReturned.publisher.eraseToAnyPublisher()
    }
    
    public var getProductWithIDResultToBeReturned: Result<Product, ProductsRepositoryError> = .success(.fixture())
    public func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductsRepositoryError> {
        getProductWithIDResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}
#endif
