import Foundation

struct ProductDTO: Decodable {
    let id: String
    let name: String
    let currency: String
    let price: Double
    let description: String
    let imageURL: String
    let reviews: [ProductReviewDTO]

    enum CodingKeys: String, CodingKey {
        case id, name, currency, price, description, reviews
        case imageURL = "imgUrl"
    }
}
