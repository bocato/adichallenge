import Foundation
import Combine
import NetworkingInterface

public typealias ReviewsRepositoryError = APIError

public protocol ReviewsRepositoryProtocol {
    func getReviewForProductWithID(_ id: Int) -> AnyPublisher<[ProductReview], ReviewsRepositoryError>
}
