import Foundation

public struct Product {
    public let id: String
    public let name: String
    public let description: String
    public let imageURL: String
    public let reviews: [ProductReview]
    
    public init(
        id: String,
        name: String,
        description: String,
        imageURL: String,
        reviews: [ProductReview]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.reviews = reviews
    }
}
