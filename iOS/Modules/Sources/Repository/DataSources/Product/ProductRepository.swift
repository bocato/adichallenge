import Foundation
import Combine
import RepositoryInterface
import NetworkingInterface

public final class ProductRepository: ProductRepositoryProtocol {
    // MARK: - Dependencies

    private let httpDispatcher: HTTPRequestDispatcherProtocol
    private let jsonDecoder: JSONDecoder

    // MARK: - Initialization

    public init(
        httpDispatcher: HTTPRequestDispatcherProtocol,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpDispatcher = httpDispatcher
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - Public API

    public func getAll() -> AnyPublisher<[Product], ProductRepositoryError> {
        let request: DefaultAPIRequest = .init(
            method: .get,
            path: "/products"
        )
        
        return httpDispatcher
            .executeRequest(request)
            .tryMap { [jsonDecoder] data in
                let decodedResponse = try data.decoded(using: jsonDecoder) as [ProductDTO]
                let domainModels = decodedResponse.map(Product.init(dto:))
                return domainModels
            }
            .mapError { $0 as ProductRepositoryError }
            .eraseToAnyPublisher()
    }

    public func getProductWithID(_ id: Int) -> AnyPublisher<ProductComplete, ProductRepositoryError> {
        let path = "/products/\(id)"
        let request: DefaultAPIRequest = .init(
            method: .get,
            path: path
        )
        
        return httpDispatcher
            .executeRequest(request)
            .tryMap { [jsonDecoder] data in
                let decodedResponse = try data.decoded(using: jsonDecoder) as ProductCompleteDTO
                let domainModel: ProductComplete = .init(dto: decodedResponse)
                return domainModel
            }
            .mapError { $0 as ProductRepositoryError }
            .eraseToAnyPublisher()
    }
}
