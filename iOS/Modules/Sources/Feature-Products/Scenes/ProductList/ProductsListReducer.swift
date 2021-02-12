import ComposableArchitecture
import Combine
import FoundationKit

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
        return Effect.merge(
            data.map { product in
                environment
                    .imagesRepository
                    .getImageDataFromURL(product.imageURL)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
                    .map { $0.map(LoadingState.loaded) ?? .empty }
                    .map { .updateProductImageState(for: product.id, to: $0) }
            }
        )
        
    case .loadProductsResponse(.failure): // TODO: Handle Errors
        state.isLoading = false
        return .none
        
    case let .updateProductImageState(productID, newLoadingState):
        
        return .none
        
    case let .shouldDetailsForProductWithID(productID):
        return .none
        
    default:
        return .none
    }
}
