import Foundation
import FoundationKit
import RepositoryInterface

struct ProductDetailsState: Equatable {
    let props: Props
    var isLoading: Bool
    var apiError: EquatableErrorWrapper?
    var product: ProductViewData?
    var productImageState: LoadingState<Data>
    var isAddReviewModalShown: Bool = false
    
    init(
        props: Props,
        isLoading: Bool = false,
        apiError: EquatableErrorWrapper? = nil,
        product: ProductViewData? = nil,
        productImageState: LoadingState<Data> = .empty,
        isAddReviewModalShown: Bool = false
    ) {
        self.props = props
        self.isLoading = isLoading
        self.apiError = apiError
        self.product = product
        self.productImageState = productImageState
        self.isAddReviewModalShown = isAddReviewModalShown
    }
}
extension ProductDetailsState {
    struct Props: Equatable {
        let productName: String
        let productID: String
    }
}

#if DEBUG
extension ProductDetailsState.Props {
    static func fixture(
        productName: String = "My Product",
        productID: String = "productID"
    ) -> Self {
        .init(
            productName: productName,
            productID: productID
        )
    }
}
#endif

// MARK: - View Data Models

struct ProductViewData: Equatable {
    let name: String
    let description: String
    let price: String
    let reviews: [Review]
}
extension ProductViewData {
    struct Review: Equatable, Identifiable {
        let id: String
        let flagEmoji: String
        let rating: String
        let text: String
        
        init(
            id: String,
            flagEmoji: String,
            rating: String,
            text: String
        ) {
            self.id = id
            self.flagEmoji = flagEmoji
            self.rating = rating
            self.text = text
        }
    }
}

#if DEBUG
extension ProductViewData {
    static func fixture(
        name: String = "name",
        description: String = "description",
        price: String = "price",
        reviews: [Review] = [.fixture()]
    ) -> Self {
        .init(
            name: name,
            description: description,
            price: price,
            reviews: reviews
        )
    }
}
extension ProductViewData.Review {
    static func fixture(
        id: String = "id",
        flagEmoji: String = "🇧🇷",
        rating: String = "⭐️⭐️⭐️⭐️⭐️",
        text: String = "text"
    ) -> Self {
        .init(
            id: id,
            flagEmoji: flagEmoji,
            rating: rating,
            text: text
        )
    }
}
#endif
