import Combine
import ComposableArchitecture
import FoundationKit
import RepositoryInterface

typealias AddReviewModalReducer = Reducer<AddReviewModalState, AddReviewModalAction, AddReviewModalEnvironment>

let addReviewModalReducer = AddReviewModalReducer { state, action, environment in
    switch action {
    case let .updateReviewRating(score):
        state.rating = score
        return .none

    case let .updateReviewText(text):
        state.reviewText = text
        return .none

    case .saveReview:
        state.isLoading = true
        state.errorAlert = nil
        var rating = 0
        if let userRating = state.rating, userRating > 0 {
            rating = userRating + 1
        }
        let locale = environment.localeProvider() ?? "en_nl"
        let requestData: PostProductReviewRequestData = .init(
            productID: state.props.productID,
            locale: locale,
            rating: rating,
            text: state.reviewText
        )
        return environment
            .reviewsRepository
            .postProductReview(requestData)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AddReviewModalAction.saveReviewRequest)

    case .saveReviewRequest(.success):
        state.isLoading = false
        return Effect<AddReviewModalAction, Never>(
            value: .dismissItSelf
        )

    case .saveReviewRequest(.failure):
        state.isLoading = false
        state.errorAlert = .init(
            title: TextState(L10n.AddReviewModal.ErrorAlert.title),
            message: TextState(L10n.AddReviewModal.ErrorAlert.message)
        )
        return .none

    case .dismissItSelf:
        return .fireAndForget {
            environment.dismissClosure()
        }

    case .errorAlertDismissed:
        state.errorAlert = nil
        return .none
    }
}
