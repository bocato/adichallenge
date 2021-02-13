import ComposableArchitecture
import RepositoryInterface
import XCTest
@testable import Feature_Products

final class ProductsListReducerTests: XCTestCase {
    // MARK: - Properties
    private var initialState = ProductsListState()
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
}
