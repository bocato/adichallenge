import ComposableArchitecture
import Combine

typealias ProductsListReducer = Reducer<ProductsListState, ProductsListAction, ProductsListEnvironment>

let productsListReducer = ProductsListReducer { state, action, environment in
    switch action {
    case let .updateSearchTerm(term):
        state.searchTerm = term
        return .none
        
    case .loadData:
        state.isLoading = true
        return environment
            .productsRepository
            .getAll()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ProductsListAction.loadProductsResponse)
        
    case let .loadProductsResponse(.success(data)):
        state.isLoading = false
        return  .none
        
    case .loadProductsResponse(.failure): // TODO: Handle Errors
        state.isLoading = false
        return .none
        
    default:
        return .none
    }
}
