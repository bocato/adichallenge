import Combine
import ComposableArchitecture
import RepositoryInterface
import FoundationKit

typealias AddReviewModalReducer = Reducer<AddReviewModalState, AddReviewModalAction, AddReviewModalEnvironment>

let addReviewModalReducer = AddReviewModalReducer { state, action, environment in
//    switch action {
//    case .loadData:
//        state.isLoading = true
//        state.apiError = nil
//        return environment
//            .productsRepository
//            .getProductWithID(state.props.productID)
//            .receive(on: environment.mainQueue)
//            .catchToEffect()
//            .map(ProductDetailsAction.loadProductResponse)
//
//    case let .loadProductResponse(.success(data)):
//        state.isLoading = false
//        state.product = .init(
//            name: data.name,
//            description: data.description,
//            price: environment.currencyFormatter.format(
//                data.price,
//                currencyCode: data.currency
//            ),
//            reviews: data.reviews.map { domainObject -> ProductViewData.Review in
//                .init(
//                    id: environment.generateUUIDString(),
//                    flagEmoji: environment.emojiConverter.emojiFlag(for: domainObject.locale),
//                    rating: environment.emojiConverter.productRatingStars(for: domainObject.rating),
//                    text: domainObject.text
//                )
//            }
//        )
//        return environment
//            .imagesRepository
//            .getImageDataFromURL(data.imageURL)
//            .receive(on: environment.mainQueue)
//            .eraseToEffect()
//            .map { $0.map(LoadingState.loaded) ?? .empty }
//            .map { .updateProductImageState($0) }
//
//    case let .loadProductResponse(.failure(error)):
//        state.isLoading = false
//        state.apiError = .init(error)
//        return .none
//
//    case let .updateProductImageState(newLoadingState):
//        state.productImageState = newLoadingState
//        return .none
//    }
    return .none
}
