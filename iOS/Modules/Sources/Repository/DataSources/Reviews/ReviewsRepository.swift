import Combine
import Foundation
import NetworkingInterface
import RepositoryInterface

public final class ReviewsRepository: ReviewsRepositoryProtocol {
    // MARK: - Dependencies

    private let httpDispatcher: HTTPRequestDispatcherProtocol
    private let jsonDecoder: JSONDecoder
    private let jsonConverter: JSONConverterProtocol
    private let apiErrorMapper: APIErrorMapperProtocol

    // MARK: - Initialization

    public convenience init(
        httpDispatcher: HTTPRequestDispatcherProtocol
    ) {
        self.init(
            httpDispatcher: httpDispatcher,
            jsonDecoder: .init(),
            jsonConverter: DefaultJSONConverter(),
            apiErrorMapper: DefaultAPIErrorMapper()
        )
    }

    init(
        httpDispatcher: HTTPRequestDispatcherProtocol,
        jsonDecoder: JSONDecoder,
        jsonConverter: JSONConverterProtocol,
        apiErrorMapper: APIErrorMapperProtocol
    ) {
        self.httpDispatcher = httpDispatcher
        self.jsonDecoder = jsonDecoder
        self.jsonConverter = jsonConverter
        self.apiErrorMapper = apiErrorMapper
    }

    // MARK: - Public API

    public func getReviewsForProductWithID(_ id: String) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
        let path = "/reviews/\(id)"
        let request: DefaultAPIRequest = .init(
            method: .get,
            path: path
        )

        return httpDispatcher
            .executeRequest(request)
            .tryMap { [jsonDecoder] data in
                let decodedResponse = try data.decoded(using: jsonDecoder) as [ProductReviewDTO]
                let domainModels = decodedResponse.map(ProductReview.init(dto:))
                return domainModels
            }
            .mapError { [apiErrorMapper] in apiErrorMapper.parse($0) }
            .eraseToAnyPublisher()
    }

    public func postProductReview(_ review: PostProductReviewRequestData) -> AnyPublisher<Void, ReviewsRepositoryError> {
        let path = "/reviews/\(review.productID)"

        let bodyParameters = jsonConverter
            .convertToJSON(review)

        let request: DefaultAPIRequest = .init(
            method: .post,
            path: path,
            bodyParameters: bodyParameters
        )

        return httpDispatcher
            .executeRequest(request)
            .tryMap { _ in () }
            .mapError { [apiErrorMapper] in apiErrorMapper.parse($0) }
            .eraseToAnyPublisher()
    }
}
