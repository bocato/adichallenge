import Foundation

public struct ProductReview {
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
