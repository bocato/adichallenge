import Combine
import ComposableArchitecture
import RepositoryInterface
import FoundationKit

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
        if let userRating = state.rating {
            rating = userRating
        }
        let requestData: PostProductReviewRequestData = .init(
            productID: state.props.productID,
            locale: "", // TODO: get locale from dependency
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
        state.shouldDismissItSelf = true
        return .none
        
    case .saveReviewRequest(.failure):
        state.isLoading = false
        state.errorAlert = .init( // TODO: Review this later...
            title: .init(L10n.AddReviewModal.ErrorAlert.title),
            message: .init(L10n.AddReviewModal.ErrorAlert.message)
        )
        return .none
        
    case .cancelReview:
        state.shouldDismissItSelf = true
        return .none
        
    case .errorAlertDismissed:
        state.errorAlert = nil
        return .none
    }
}
