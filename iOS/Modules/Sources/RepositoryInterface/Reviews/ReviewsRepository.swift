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
    public func getReviewsForProductWithID(_: String) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
    
    public func postProductReview(_: PostProductReviewRequestData) -> AnyPublisher<Void, ReviewsRepositoryError> {
        Empty().eraseToAnyPublisher()
    }
}

public final class ReviewsRepositoryStub: ReviewsRepositoryProtocol {
    public init() {}
    
    public var getReviewsForProductWithIDResultToBeReturned: Result<[ProductReview], ReviewsRepositoryError> = .success([])
    public func getReviewsForProductWithID(_: String) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
        getReviewsForProductWithIDResultToBeReturned.publisher.eraseToAnyPublisher()
    }
    
    public var postProductReviewResultToBeReturned: Result<Void, ReviewsRepositoryError> = .success(())
    public func postProductReview(_: PostProductReviewRequestData) -> AnyPublisher<Void, ReviewsRepositoryError> {
        postProductReviewResultToBeReturned.publisher.eraseToAnyPublisher()
    }
}

public final class ReviewsRepositoryMock: ReviewsRepositoryProtocol {
    public init() {}
    
    public var getReviewsForProductWithIDResultToBeReturned: Result<[ProductReview], ReviewsRepositoryError> = .success([])
    public private(set) var getReviewsForProductIDPassed: String?
    public func getReviewsForProductWithID(_ id: String) -> AnyPublisher<[ProductReview], ReviewsRepositoryError> {
        getReviewsForProductIDPassed = id
        return getReviewsForProductWithIDResultToBeReturned
            .publisher
            .eraseToAnyPublisher()
    }
    
    public var postProductReviewResultToBeReturned: Result<Void, ReviewsRepositoryError> = .success(())
    public private(set) var postProductReviewRequestPassed: PostProductReviewRequestData?
    public func postProductReview(_ review: PostProductReviewRequestData) -> AnyPublisher<Void, ReviewsRepositoryError> {
        postProductReviewRequestPassed = review
        return postProductReviewResultToBeReturned
            .publisher
            .eraseToAnyPublisher()
    }
}
#endif
