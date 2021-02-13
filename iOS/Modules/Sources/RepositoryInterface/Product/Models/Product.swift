import Foundation

public struct Product {
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
