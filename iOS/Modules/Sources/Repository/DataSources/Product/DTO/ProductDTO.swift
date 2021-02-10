import Foundation

struct ProductDTO: Decodable {
    let id: String
    let name: String
    let description: String
    let imageURL: String
    let reviews: [ProductReviewDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, reviews
        case imageURL = "imgUrl"
    }
}
