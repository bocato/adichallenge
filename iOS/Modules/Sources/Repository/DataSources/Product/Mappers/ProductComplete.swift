import Foundation
import RepositoryInterface

extension ProductComplete {
    init(dto: ProductCompleteDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            currency: dto.currency,
            price: dto.price
        )
    }
}
