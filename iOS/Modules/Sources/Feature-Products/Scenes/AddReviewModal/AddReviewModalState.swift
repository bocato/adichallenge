import ComposableArchitecture
import Foundation
import FoundationKit
import RepositoryInterface

struct AddReviewModalState: Equatable {
    let props: Props
    var isLoading: Bool
    var rating: Int?
    var reviewText: String
    var errorAlert: AlertState<AddReviewModalAction>?
    var shouldDismissItSelf: Bool

    init(
        props: Props,
        isLoading: Bool = false,
        rating: Int? = nil,
        reviewText: String = "",
        errorAlert: AlertState<AddReviewModalAction>? = nil,
        shouldDismissItSelf: Bool = false
    ) {
        self.props = props
        self.isLoading = isLoading
        self.rating = rating
        self.reviewText = reviewText
        self.errorAlert = errorAlert
        self.shouldDismissItSelf = shouldDismissItSelf
    }
}

extension AddReviewModalState {
    struct Props: Equatable {
        let productID: String
    }
}

#if DEBUG
    extension AddReviewModalState.Props {
        static func fixture(
            productID: String = "productID"
        ) -> Self {
            .init(
                productID: productID
            )
        }
    }
#endif

// MARK: - View Data Models

#if DEBUG

#endif
