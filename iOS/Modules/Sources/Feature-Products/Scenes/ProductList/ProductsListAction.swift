import Foundation
import FoundationKit
import RepositoryInterface

enum ProductsListAction: Equatable {
    case updateSearchTerm(String)
    case loadData
    case loadProductsResponse(Result<[Product], ProductsRepositoryError>)
    case updateProductImageState(for: String, to: LoadingState<Data>)
    case shouldDetailsForProductWithID(String)
    case filterProductsByTerm(String)
}
