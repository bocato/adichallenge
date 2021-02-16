import Foundation
import FoundationKit
import RepositoryInterface

struct AddReviewModalState: Equatable {
    let props: Props
    var isLoading: Bool
    var apiError: EquatableErrorWrapper?
    
    init(
        props: Props,
        isLoading: Bool = false,
        apiError: EquatableErrorWrapper? = nil
    ) {
        self.props = props
        self.isLoading = isLoading
        self.apiError = apiError
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
