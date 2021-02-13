import Foundation

public struct Product: Equatable {
    public let id: String
    public let name: String
    public let currency: String
    public let price: Double
    public let description: String
    public let imageURL: String
    public let reviews: [ProductReview]

    public init(
        id: String,
        name: String,
        currency: String,
        price: Double,
        description: String,
        imageURL: String,
        reviews: [ProductReview]
    ) {
        self.id = id
        self.name = name
        self.currency = currency
        self.price = price
        self.description = description
        self.imageURL = imageURL
        self.reviews = reviews
    }
}
#if DEBUG
extension Product {
    public static func fixture(
        id: String = "id",
        name: String = "name",
        currency: String = "currency",
        price: Double = .zero,
        description: String = "description",
        imageURL: String = "imageURL",
        reviews: [ProductReview] = []
    ) -> Self {
        .init(
            id: id,
            name: name,
            currency: currency,
            price: price,
            description: description,
            imageURL: imageURL,
            reviews: reviews
        )
    }
}
#endif
