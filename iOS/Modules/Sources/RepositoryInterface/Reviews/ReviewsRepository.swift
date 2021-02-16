import Combine
import Foundation
import NetworkingInterface

public typealias ReviewsRepositoryError = APIError

public protocol ReviewsRepositoryProtocol {
    func getReviewsForProductWithID(_ id: String) -> AnyPublisher<[ProductReview], ReviewsRepositoryError>
    func postProductReview(_ review: PostProductReviewRequestData) -> AnyPublisher<Void, ReviewsRepositoryError>
}

#if DEBUG
public final class ReviewsRepositoryDummy: ReviewsRepositoryProtocol {
    public init() {}
    public func getReviewsForProductWithID(_ id: String) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
    public func postProductReview(_ review: PostProductReviewRequestData) -> AnyPublisher<Void, ReviewsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
}
#endif
