import Foundation

struct ProductReviewDTO: Decodable {
    let productID: String
    let locale: String
    let rating: Int
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case locale, rating, text
        case productID = "productId"
    }
}
