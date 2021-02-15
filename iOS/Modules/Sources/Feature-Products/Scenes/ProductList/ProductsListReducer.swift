import Combine
import ComposableArchitecture
import FoundationKit

typealias ProductsListReducer = Reducer<ProductsListState, ProductsListAction, ProductsListEnvironment>

let productsListReducer = ProductsListReducer { state, action, environment in
    switch action {
    case let .updateSearchTerm(term):
        state.searchInput = term
        guard term.count >= 3 else {
            return .none
        }
        return .init(value: .filterProductsByTerm(term))

    case .loadData:
        state.isLoading = true
        state.apiError = nil
        state.productRows = []
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
                groupName: "GROUP NAME?", // TODO: CHECK THIS PROPERTY...
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
        
    case let .filterProductsByTerm(filter):
        let cleanFilter = filter.lowercased()
        let filterResult = state
            .productRows
            .filter {
                $0.description.lowercased().contains(cleanFilter) ||
                    $0.name.lowercased().contains(cleanFilter)
            }
        state.filteredProductRows = filterResult.isEmpty ? nil : filterResult
        return .none
    }
}
