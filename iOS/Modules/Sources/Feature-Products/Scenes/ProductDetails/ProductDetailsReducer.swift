import Combine
import ComposableArchitecture
import RepositoryInterface
import FoundationKit

typealias ProductDetailsReducer = Reducer<ProductDetailsState, ProductDetailsAction, ProductDetailsEnvironment>

let productDetailsReducer = ProductDetailsReducer { state, action, environment in
    switch action {
    case .loadData:
        state.isLoading = true
        state.apiError = nil
        return environment
            .productsRepository
            .getProductWithID(state.props.productID)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ProductDetailsAction.loadProductResponse)

    case let .loadProductResponse(.success(data)):
        state.isLoading = false
        state.product = .init(
            name: data.name,
            description: data.description,
            price: environment.currencyFormatter.format(
                data.price,
                currencyCode: data.currency
            ),
            reviews: data.reviews.map { domainObject -> ProductViewData.Review in
                .init(
                    flagEmoji: environment.emojiConverter.emojiFlag(for: domainObject.locale),
                    rating: environment.emojiConverter.productRatingStars(for: domainObject.rating),
                    text: domainObject.text
                )
            }
        )
        return .none // TODO: Load image
//        return Effect.init {
//            environment
//                .imagesRepository
//                .getImageDataFromURL(data.imageURL)
//                .receive(on: environment.mainQueue)
//                .eraseToEffect()
//                .map { data -> LoadingState<Data> in
//                    guard let data = data else {
//                        return .empty
//                    }
//                    return .loaded(data)
//                }
//                .map { .updateProductImageState }
//        }

    case let .loadProductResponse(.failure(error)):
        state.isLoading = false
        state.apiError = .init(error)
        return .none

    case let .updateProductImageState(newLoadingState):
        state.productImageState = newLoadingState
        return .none
    }
}
