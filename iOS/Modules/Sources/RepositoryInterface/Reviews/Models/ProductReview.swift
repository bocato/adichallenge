import Foundation

public struct ProductReview: Equatable {
    public let productID: String
    public let locale: String
    public let rating: Int
    public let text: String

    public init(
        productID: String,
        locale: String,
        rating: Int,
        text: String
    ) {
        self.productID = productID
        self.locale = locale
        self.rating = rating
        self.text = text
    }
}

#if DEBUG
    extension ProductReview {
        public static func fixture(
            productID: String = "Product ID",
            locale: String = "pt-BR",
            rating: Int = 2,
            text: String = "text"
        ) -> Self {
            .init(
                productID: productID,
                locale: locale,
                rating: rating,
                text: text
            )
        }
    }
#endif
