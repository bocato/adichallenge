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
    struct Review: Equatable {
        let locale: String
        let rating: Int
        let text: String
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
        locale: String = "locale",
        rating: Int = 5,
        text: String = "text"
    ) -> Self {
        .init(
            locale: locale,
            rating: rating,
            text: text
        )
    }
}
#endif
