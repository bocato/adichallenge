import Foundation
import RepositoryInterface

extension Product {
    init(dto: ProductDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            currency: dto.currency,
            price: dto.price,
            description: dto.description,
            imageURL: dto.imageURL,
            reviews: dto.reviews.map(ProductReview.init)
        )
    }
}
