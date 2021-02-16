import ComposableArchitecture
import RepositoryInterface
import NetworkingInterface
import FoundationKit
import XCTest
@testable import Feature_Products

final class ProductDetailsReducerTests: XCTestCase {
    // MARK: - Properties
    
    private var initialState: ProductDetailsState = .init(props: .fixture())
    private let productsRepositoryStub = ProductsRepositoryStub()
    private let imagesRepositoryStub = ImagesRepositoryStub()
    private let mainQueueFake = DispatchQueue.testScheduler
    private lazy var productDetailsEnvironment: ProductDetailsEnvironment = .fixture()
    private lazy var testStore: TestStore = {
        return .init(
            initialState: initialState,
            reducer: productDetailsReducer,
            environment: productDetailsEnvironment
        )
    }()
    
    // MARK: - Tests
    
    func test_loadData_whenAPISucceeds_itShouldSetProductInfoAndLoadImage() {
        // Given
        let productMock: Product = .fixture(
            currency: "",
            price: 1.23,
            reviews: [
                .fixture(locale: "pt_BR", rating: 2),
                .fixture(locale: "pt_BR", rating: 2),
            ]
        )
        initialState.product = nil
        productDetailsEnvironment = .fixture(
            productsRepository: productsRepositoryStub,
            imagesRepository: imagesRepositoryStub,
            currencyFormatter: DefaultCurrencyFormatter(),
            emojiConverter: DefaultEmojiConverter(),
            generateUUIDString: { "id" },
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )
        productsRepositoryStub.getProductWithIDResultToBeReturned = .success(productMock)
        
        let imageDataMock: Data = .init()
        imagesRepositoryStub.imageDataToBeReturned = imageDataMock
        
        // When / Then
        testStore.assert(
            .send(.loadData) { nextState in
                nextState.isLoading = true
                nextState.apiError = nil
                nextState.product = nil
            },
            .do { self.mainQueueFake.advance() },
            .receive(.loadProductResponse(.success(productMock))) { nextState in
                nextState.isLoading = false
                nextState.product = .fixture(
                    name: productMock.name,
                    description: productMock.description,
                    price: "€ 1,23",
                    reviews: [
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️⭐️"),
                        .fixture(flagEmoji: "🇧🇷", rating: "⭐️⭐️")
                    ]
                )
            },
            .receive(.updateProductImageState(.loaded(imageDataMock))) { nextState in
                nextState.productImageState = .loaded(imageDataMock)
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
            .do { self.mainQueueFake.advance() },
            .receive(.loadProductResponse(.failure(apiErrorMock))) { nextState in
                nextState.isLoading = false
                nextState.apiError = .init(apiErrorMock)
            }
        )
    }
}
