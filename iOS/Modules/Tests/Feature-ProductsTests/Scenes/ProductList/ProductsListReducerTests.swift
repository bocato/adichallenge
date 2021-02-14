import ComposableArchitecture
import RepositoryInterface
import NetworkingInterface
import FoundationKit
import XCTest
@testable import Feature_Products

final class ProductsListReducerTests: XCTestCase {
    // MARK: - Properties
    private var initialState = ProductsListState()
    private let productsRepositoryStub = ProductsRepositoryStub()
    private let imagesRepositoryStub = ImagesRepositoryStub()
    private let currencyFormatterStub = CurrencyFormatterStub()
    private let mainQueueFake = DispatchQueue.testScheduler
    private lazy var productsListEnvironment: ProductsListEnvironment = .fixture()
    private lazy var testStore: TestStore = {
        return .init(
            initialState: initialState,
            reducer: productsListReducer,
            environment: productsListEnvironment
        )
    }()
    
    // MARK: - Tests
    
    func test_updateSearchTerm_whenInputHasLessThan3Letters_itShoulUpdateTheStateAndShowFilteringView() {
        // Given
        let searchTerm = "Ab"
        // When / Then
        testStore.assert(
            .send(.updateSearchTerm(searchTerm)) { nextState in
                nextState.searchInput = searchTerm
                XCTAssertEqual(nextState.isFiltering, true)
                XCTAssertEqual(nextState.showFilteringView, true)
            }
        )
    }
    
    func test_updateSearchTerm_whenInputHasMoreThan3LettersAndProductRowsIsEmpty_itShouldShowNoProductsWereFound() {
        // Given
        let searchTerm = "Abc"
        initialState.productRows = []
        // When / Then
        testStore.assert(
            .send(.updateSearchTerm(searchTerm)) { nextState in
                nextState.searchInput = searchTerm
                XCTAssertEqual(nextState.isFiltering, true)
                XCTAssertEqual(nextState.showFilteringView, false)
                XCTAssertEqual(nextState.showEmptyFilterResults, true)
            },
            .receive(.filterProductsByTerm(searchTerm)) { nextState in
                nextState.filteredProductRows = []
            }
        )
    }
    
    func test_loadData_whenAPISucceeds_itShouldSetProductRowsAndLoadProductImages() {
        // Given
        initialState.productRows = []
        productsListEnvironment = .fixture(
            productsRepository: productsRepositoryStub,
            imagesRepository: imagesRepositoryStub,
            currencyFormatter: DefaultCurrencyFormatter(),
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )
        
        let firstProduct: Product = .fixture(
            name: "Product A",
            currency: "",
            price: 1.23,
            imageURL: "ImageURL A"
        )
        let productsMock: [Product] = [firstProduct]
        productsRepositoryStub.getAllResultToBeReturned = .success(productsMock)
        
        let imageDataMock: Data = .init()
        imagesRepositoryStub.imageDataToBeReturned = imageDataMock
        
        // When / Then
        testStore.assert(
            .send(.loadData) { nextState in
                nextState.isLoading = true
            },
            .do { self.mainQueueFake.advance() },
            .receive(.loadProductsResponse(.success(productsMock))) { nextState in
                nextState.isLoading = false
                nextState.productRows = [
                    .fixture(
                        id: firstProduct.id,
                        groupName: "GROUP NAME?", // TODO: CHECK THIS PROPERTY...
                        name: firstProduct.name,
                        description: firstProduct.description,
                        price: "€ 1,23"
                    )
                ]
            },
            .receive(.updateProductImageState(for: firstProduct.id, to: .loaded(imageDataMock))) { nextState in
                nextState.productImageStates = [
                    "\(firstProduct.id)": .loaded(imageDataMock)
                ]
            }
        )
    }
    
    func test_loadData_whenAPIFails_shouldPresentAPIError() {
        // Given
        initialState.productRows = []
        productsListEnvironment = .fixture(
            productsRepository: productsRepositoryStub,
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )
        
        let errorMock: NSError = .init(domain: "APIError", code: -1, userInfo: nil)
        let apiErrorMock: APIError = .init(rawError: errorMock)
        productsRepositoryStub.getAllResultToBeReturned = .failure(apiErrorMock)
        
        // When / Then
        testStore.assert(
            .send(.loadData) { nextState in
                nextState.isLoading = true
            },
            .do { self.mainQueueFake.advance() },
            .receive(.loadProductsResponse(.failure(apiErrorMock))) { nextState in
                nextState.isLoading = false
                nextState.apiError = .init(apiErrorMock)
            }
        )
    }
    
    func test_filterProductsByTerm_whenTermIsValid_shouldPresentOnlyFilteredProductRows() {
        // Given
        let searchTerm = "Abc"
        initialState.productRows = [
            .fixture(name: "Abcdefg"),
            .fixture(description: "Abcdefg"),
            .fixture(name: "Banana"),
            .fixture(description: "Yellow fruit"),
        ]
        // When / Then
        testStore.assert(
            .send(.updateSearchTerm(searchTerm)) { nextState in
                nextState.searchInput = searchTerm
                XCTAssertEqual(nextState.isFiltering, true)
                XCTAssertEqual(nextState.showFilteringView, false)
            },
            .receive(.filterProductsByTerm(searchTerm)) { nextState in
                nextState.filteredProductRows = [
                    .fixture(name: "Abcdefg"),
                    .fixture(description: "Abcdefg"),
                ]
                XCTAssertEqual(nextState.showEmptyFilterResults, false)
            }
        )
    }
}
