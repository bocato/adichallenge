import Combine
import Foundation
import NetworkingInterface

public typealias ReviewsRepositoryError = APIError

public protocol ReviewsRepositoryProtocol {
    func getReviewForProductWithID(_ id: Int) -> AnyPublisher<[ProductReview], ReviewsRepositoryError>
}

#if DEBUG
public final class ReviewsRepositoryDummy: ReviewsRepositoryProtocol {
    public init() {}
    public func getReviewForProductWithID(_ id: Int) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
}
#endif
