import Foundation
import FoundationKit
import RepositoryInterface

enum ProductsListAction {
    case updateSearchTerm(String)
    case loadData
    case loadProductsResponse(Result<[Product], ProductRepositoryError>)
    case updateProductImageState(for: String, to: LoadingState<Data>)
    case shouldDetailsForProductWithID(String)
    case filterProductsByTerm(String)
}
