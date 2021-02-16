import Foundation

public struct PostProductReviewRequestData: Encodable {
    public let productID: String
    public let locale: String
    public let rating: Int
    public let text: String

    enum CodingKeys: String, CodingKey {
        case locale, rating, text
        case productID = "productId"
    }
    
    public  init(
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
G
