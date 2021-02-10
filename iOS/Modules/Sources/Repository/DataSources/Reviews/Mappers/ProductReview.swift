import RepositoryInterface

extension ProductReview {
    init(dto: ProductReviewDTO) {
        self.init(
            productID: dto.productID,
            locale: dto.locale,
            rating: dto.rating,
            text: dto.text
        )
    }
}
