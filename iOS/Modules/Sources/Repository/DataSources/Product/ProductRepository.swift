import Combine
import Foundation
import NetworkingInterface
import RepositoryInterface

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
            path: "/product"
        )

        return httpDispatcher
            .executeRequest(request)
            .tryMap { [jsonDecoder] data in
                let decodedResponse = try data.decoded(using: jsonDecoder) as [ProductDTO]
                let domainModels = decodedResponse.map(Product.init(dto:))
                return domainModels
            }
            .mapError { APIError(rawError: $0) }
            .eraseToAnyPublisher()
    }

    public func getProductWithID(_ id: Int) -> AnyPublisher<Product, ProductRepositoryError> {
        let path = "/product/\(id)"
        let request: DefaultAPIRequest = .init(
            method: .get,
            path: path
        )

        return httpDispatcher
            .executeRequest(request)
            .tryMap { [jsonDecoder] data in
                let decodedResponse = try data.decoded(using: jsonDecoder) as ProductDTO
                let domainModel: Product = .init(dto: decodedResponse)
                return domainModel
            }
            .mapError { APIError(rawError: $0) }
            .eraseToAnyPublisher()
    }
}
