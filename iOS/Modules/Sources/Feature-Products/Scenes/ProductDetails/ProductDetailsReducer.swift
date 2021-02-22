import Combine
import ComposableArchitecture
import FoundationKit
import RepositoryInterface

typealias ProductDetailsReducer = Reducer<ProductDetailsState, ProductDetailsAction, ProductDetailsEnvironment>

let productDetailsReducer = ProductDetailsReducer { state, action, environment in
    switch action {
    case .loadData:
        state.isLoading = true
        state.apiError = nil
        state.product = nil
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
                    id: environment.generateUUIDString(),
                    flagEmoji: environment.emojiConverter.emojiFlag(for: domainObject.locale),
                    rating: environment.emojiConverter.productRatingStars(for: domainObject.rating),
                    text: domainObject.text
                )
            }
        )
        return .merge(
            .init(
                environment
                    .imagesRepository
                    .getImageDataFromURL(data.imageURL)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
                    .map { $0.map(LoadingState.loaded) ?? .empty }
                    .map { .updateProductImageState($0) }
            ),
            .init(value: .fetchProductReviews)
        )

    case let .loadProductResponse(.failure(error)):
        state.isLoading = false
        state.apiError = .init(error)
        return .none

    case let .updateProductImageState(newLoadingState):
        state.productImageState = newLoadingState
        return .none

    case .showAddReviewModal:
        state.isAddReviewModalShown = true
        return .none

    case let .addReviewModalDismissed(shouldUpdateReviews):
        state.isAddReviewModalShown = false
        if shouldUpdateReviews {
            return .init(value: .loadData)
        }
        return .none

    case .fetchProductReviews:
        return environment
            .reviewsRepository
            .getReviewsForProductWithID(state.props.productID)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(ProductDetailsAction.fetchProductReviewsResponse)

    case let .fetchProductReviewsResponse(result):
        if case let .success(data) = result, let currentProductData = state.product {
            let reviewModels = data.map { domainObject -> ProductViewData.Review in
                .init(
                    id: environment.generateUUIDString(),
                    flagEmoji: environment.emojiConverter.emojiFlag(for: domainObject.locale),
                    rating: environment.emojiConverter.productRatingStars(for: domainObject.rating),
                    text: domainObject.text
                )
            }
            state.product = .init(
                name: currentProductData.name,
                description: currentProductData.description,
                price: currentProductData.price,
                reviews: currentProductData.reviews + reviewModels
            )
        }
        return .none
    }
}
