import Foundation
import FoundationKit
import RepositoryInterface

enum AddReviewModalAction: Equatable {
    case updateReviewRating(Int)
    case updateReviewText(String)
    case saveReview
    case saveReviewRequest(Result<Void, ReviewsRepositoryError>)
    case dismissItSelf
    case errorAlertDismissed

    static func == (lhs: AddReviewModalAction, rhs: AddReviewModalAction) -> Bool {
        switch (lhs, rhs) {
        case let (.updateReviewRating(r1), .updateReviewRating(r2)):
            return r1 == r2
        case let (.updateReviewText(t1), .updateReviewText(t2)):
            return t1 == t2
        case (.saveReview, .saveReview):
            return true
        case (.saveReviewRequest(.success), .saveReviewRequest(.success)):
            return true
        case let (.saveReviewRequest(.failure(e1)), .saveReviewRequest(.failure(e2))):
            return e1 == e2
        case (.dismissItSelf, .dismissItSelf):
            return true
        case (.errorAlertDismissed, .errorAlertDismissed):
            return true
        default:
            return false
        }
    }
}
