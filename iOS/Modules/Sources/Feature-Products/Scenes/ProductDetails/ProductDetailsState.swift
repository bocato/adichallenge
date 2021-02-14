import Foundation
import FoundationKit
import RepositoryInterface

struct ProductDetailsState: Equatable {
    let productID: String
    var isLoading: Bool
    var apiError: EquatableErrorWrapper?
    var product: ProductViewData?
    var productImageState: LoadingState<Data>
    
    init(
        productID: String,
        isLoading: Bool = false,
        apiError: EquatableErrorWrapper? = nil,
        product: ProductViewData? = nil,
        productImageState: LoadingState<Data> = .empty
    ) {
        self.productID = productID
        self.isLoading = isLoading
        self.apiError = apiError
        self.product = product
        self.productImageState = productImageState
    }
}

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
        let rating: Int
        let text: String
        
        fileprivate init(
            id: String,
            flagEmoji: String,
            rating: Int,
            text: String
        ) {
            self.id = id
            self.flagEmoji = flagEmoji
            self.rating = rating
            self.text = text
        }
        
        init(
            flagEmoji: String,
            rating: Int,
            text: String
        ) {
            self.init(
                id: UUID().uuidString,
                flagEmoji: flagEmoji,
                rating: rating,
                text: text
            )
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
        rating: Int = 5,
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
