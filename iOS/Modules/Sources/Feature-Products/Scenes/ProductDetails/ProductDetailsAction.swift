import Foundation
import FoundationKit
import RepositoryInterface

enum ProductDetailsAction: Equatable {
    case loadData
    case loadProductResponse(Result<Product, ProductsRepositoryError>)
    case updateProductImageState(LoadingState<Data>)
    case showAddReviewModal
    case addReviewModalDismissed
}
