import Foundation

public struct ProductComplete {
    public let id: String
    public let name: String
    public let description: String
    public let currency: String
    public let price: Double
    
    public init(
        id: String,
        name: String,
        description: String,
        currency: String,
        price: Double
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.currency = currency
        self.price = price
    }
}
