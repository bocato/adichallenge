import Foundation
import RepositoryInterface

enum ProductsListAction {
    case updateSearchTerm(String)
    case loadData
    case loadProductsResponse(Result<[Product], ProductRepositoryError>)
    case shouldDetailsForProductWithID(String)
}
