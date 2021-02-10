import ComposableArchitecture
import Combine

typealias ProductsListReducer = Reducer<ProductsListState, ProductsListAction, ProductsListEnvironment>

let productsListReducer = ProductsListReducer { state, action, environment in
    switch action {
    case let .updateSearchTerm(term):
        state.searchTerm = term
        return .none
    }
}
