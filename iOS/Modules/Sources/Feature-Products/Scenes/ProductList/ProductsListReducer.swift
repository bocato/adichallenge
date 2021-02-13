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
        state.productRows = data.map { product in
            .init(
                id: product.id,
                groupName: "GROUP NAME?",
                name: product.name,
                description: product.description,
                price: environment.currencyFormatter.format(product.price, currencyCode: product.currency)
            )
        }
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
        
    case let .loadProductsResponse(.failure(error)):
        state.isLoading = false
        state.apiError = .init(error)
        return .none
        
    case let .updateProductImageState(productID, newLoadingState):
        state.productImageStates[productID] = newLoadingState
        return .none
        
    case let .shouldDetailsForProductWithID(productID):
        state.selectedProductID = productID // @TODO: Open Details Scene
        return .none
    }
}
