import Combine
import Foundation
import NetworkingInterface
import RepositoryInterface

public final class ProductsRepository: ProductsRepositoryProtocol {
    // MARK: - Dependencies

    private let httpDispatcher: HTTPRequestDispatcherProtocol
    private let jsonDecoder: JSONDecoder
    private let apiErrorMapper: APIErrorMapperProtocol

    // MARK: - Initialization

    public convenience init(httpDispatcher: HTTPRequestDispatcherProtocol) {
        self.init(
            httpDispatcher: httpDispatcher,
            jsonDecoder: .init(),
            apiErrorMapper: DefaultAPIErrorMapper()
        )
    }

    init(
        httpDispatcher: HTTPRequestDispatcherProtocol,
        jsonDecoder: JSONDecoder,
        apiErrorMapper: APIErrorMapperProtocol
    ) {
        self.httpDispatcher = httpDispatcher
        self.jsonDecoder = jsonDecoder
        self.apiErrorMapper = apiErrorMapper
    }

    // MARK: - Public API

    public func getAll() -> AnyPublisher<[Product], ProductsRepositoryError> {
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
            .mapError { [apiErrorMapper] in apiErrorMapper.parse($0) }
            .eraseToAnyPublisher()
    }

    public func getProductWithID(_ id: String) -> AnyPublisher<Product, ProductsRepositoryError> {
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
            .mapError { [apiErrorMapper] in apiErrorMapper.parse($0) }
            .eraseToAnyPublisher()
    }
}
