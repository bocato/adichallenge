import Foundation

public struct ProductCompleteDTO: Decodable {
    public let id: String
    public let name: String
    public let description: String
    public let currency: String
    public let price: Double
}
