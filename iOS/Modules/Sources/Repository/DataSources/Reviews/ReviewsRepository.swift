import Combine
import Foundation
import NetworkingInterface
import RepositoryInterface

public final class ReviewsRepository: ReviewsRepositoryProtocol {
    // MARK: - Dependencies

    private let httpDispatcher: HTTPRequestDispatcherProtocol
    private let jsonDecoder: JSONDecoder

    // MARK: - Initialization

    init(
        httpDispatcher: HTTPRequestDispatcherProtocol,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpDispatcher = httpDispatcher
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - Public API

    public func getReviewForProductWithID(_ id: Int) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
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
            .mapError { $0 as ReviewsRepositoryError }
            .eraseToAnyPublisher()
    }
}
