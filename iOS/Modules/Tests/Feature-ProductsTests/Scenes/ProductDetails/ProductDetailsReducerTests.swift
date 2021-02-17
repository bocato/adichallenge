import ComposableArchitecture
@testable import Feature_Products
import FoundationKit
import NetworkingInterface
import RepositoryInterface
import XCTest

final class ProductDetailsReducerTests: XCTestCase {
    // MARK: - Properties

    private var initialState: ProductDetailsState = .init(props: .fixture())
    private let productsRepositoryStub = ProductsRepositoryStub()
    private let imagesRepositoryStub = ImagesRepositoryStub()
    private let reviewsRepositoryStub = ReviewsRepositoryStub()
    private let mainQueueFake = DispatchQueue.testScheduler
    private lazy var productDetailsEnvironment: ProductDetailsEnvironment = .fixture()
    private lazy var testStore: TestStore = {
        .init(
            initialState: initialState,
            reducer: productDetailsReducer,
            environment: productDetailsEnvironment
        )
    }()

    // MARK: - Tests

    func test_loadData_whenBothAPISucceeds_itShouldSetProductInfo_loadImage_andThenLoadReviews() {
        // Given
        initialState.product = nil
        productDetailsEnvironment = .fixture(
            productsRepository: productsRepositoryStub,
            imagesRepository: imagesRepositoryStub,
            reviewsRepository: reviewsRepositoryStub,
            currencyFormatter: DefaultCurrencyFormatter(),
            emojiConverter: DefaultEmojiConverter(),
            generateUUIDString: { "id" },
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )
        
        let productMock: Product = .fixture(
            currency: "",
            price: 1.23,
            reviews: [
                .fixture(locale: "pt-BR", rating: 1),
                .fixture(locale: "pt-BR", rating: 2),
            ]
        )
        productsRepositoryStub.getProductWithIDResultToBeReturned = .success(productMock)

        let imageDataMock: Data = .init()
        imagesRepositoryStub.imageDataToBeReturned = imageDataMock
        
        let newReviewsMock: [ProductReview] = [
            .fixture(productID: "User Review  1", rating: 3),
            .fixture(productID: "User Review  2", rating: 4),
        ]
        reviewsRepositoryStub.getReviewsForProductWithIDResultToBeReturned = .success(newReviewsMock)

        // When / Then
        testStore.assert(
            .send(.loadData) { nextState in
                nextState.isLoading = true
                nextState.apiError = nil
                nextState.product = nil
            },
            .do { [mainQueueFake] in mainQueueFake.advance() },
            .receive(.loadProductResponse(.success(productMock))) { nextState in
                nextState.isLoading = false
                nextState.product = .fixture(
                    name: productMock.name,
                    description: productMock.description,
                    price: "€ 1,23",
                    reviews: [
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️"),
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️⭐️")
                    ]
                )
            },
            .receive(.fetchProductReviews),
            .receive(.updateProductImageState(.loaded(imageDataMock))) { nextState in
                nextState.productImageState = .loaded(imageDataMock)
            },
            .receive(.fetchProductReviewsResponse(.success(newReviewsMock))) { nextState in
                nextState.product = .fixture(
                    name: productMock.name,
                    description: productMock.description,
                    price: "€ 1,23",
                    reviews: [
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️"),
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️⭐️"),
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️⭐️⭐️"),
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️⭐️⭐️⭐️")
                    ]
                )
            }
        )
    }

    func test_loadData_whenAPIFails_shouldPresentAPIError() {
        // Given
        initialState.product = nil
        productDetailsEnvironment = .fixture(
            productsRepository: productsRepositoryStub,
            imagesRepository: imagesRepositoryStub,
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )

        let apiErrorMock: APIError = .fixture()
        productsRepositoryStub.getProductWithIDResultToBeReturned = .failure(apiErrorMock)

        // When / Then
        testStore.assert(
            .send(.loadData) { nextState in
                nextState.isLoading = true
            },
            .do { [mainQueueFake] in mainQueueFake.advance() },
            .receive(.loadProductResponse(.failure(apiErrorMock))) { nextState in
                nextState.isLoading = false
                nextState.apiError = .init(apiErrorMock)
            }
        )
    }
    
    func test_showAddReviewModal_shouldSetIsAddReviewModalShown() {
        testStore.assert(
            .send(.showAddReviewModal) { nextState in
                nextState.isAddReviewModalShown = true
            }
        )
    }
    
    func test_addReviewModalDismissed_whenViewsUpdateIsNotNeeded_shouldDismissAddReviewModal() {
        testStore.assert(
            .send(.addReviewModalDismissed(false)) { nextState in
                nextState.isAddReviewModalShown = false
            }
        )
    }
    
    func test_addReviewModalDismissed_whenViewsUpdateIsNeeded_shouldLoadData() {
        testStore.assert(
            .send(.addReviewModalDismissed(true)) { nextState in
                nextState.isAddReviewModalShown = false
            },
            .receive(.loadData) { nextState in
                nextState.isLoading = true
                nextState.apiError = nil
                nextState.product = nil
            }
        )
    }
}
