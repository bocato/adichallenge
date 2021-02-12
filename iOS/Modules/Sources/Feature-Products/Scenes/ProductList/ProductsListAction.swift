import Foundation
import RepositoryInterface
import FoundationKit

enum ProductsListAction {
    case updateSearchTerm(String)
    case loadData
    case loadProductsResponse(Result<[Product], ProductRepositoryError>)
    case updateProductImageState(for: String, to: LoadingState<Data>)
    case shouldDetailsForProductWithID(String)
}
