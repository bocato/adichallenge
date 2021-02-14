import Foundation
import FoundationKit
import RepositoryInterface

struct ProductsListState: Equatable {
    var isLoading: Bool
    var apiError: EquatableErrorWrapper?
    var searchInput: String
    var productRows: [ProductRowData]
    var filteredProductRows: [ProductRowData]?
    var productImageStates: [String: LoadingState<Data>]
    var selectedProductID: String?
    
    init(
        isLoading: Bool = false,
        apiError: EquatableErrorWrapper? = nil,
        searchInput: String = "",
        productRows: [ProductRowData] = [],
        filteredProductRows: [ProductRowData]? = nil,
        productImageStates: [String: LoadingState<Data>] = [:],
        selectedProductID: String? = nil
    ) {
        self.isLoading = isLoading
        self.apiError = apiError
        self.searchInput = searchInput
        self.productRows = productRows
        self.filteredProductRows = filteredProductRows
        self.productImageStates = productImageStates
        self.selectedProductID = selectedProductID
    }
}

extension ProductsListState {
    var isFiltering: Bool { searchInput.count > 0 }
    var showEmptyContentView: Bool { productRows.isEmpty && !isLoading && apiError == nil }
    var showFilteringView: Bool { searchInput.count > 0 && searchInput.count < 3 }
    var showEmptyFilterResults: Bool { searchInput.count >= 3 && filteredProductRows?.isEmpty == true }
}

// MARK: - View Data Models

struct ProductRowData: Identifiable, Equatable {
    let id: String
    let groupName: String
    let name: String
    let description: String
    let price: String // formatted
}
#if DEBUG
extension ProductRowData {
    static func fixture(
        id: String = "id",
        groupName: String = "groupName",
        name: String = "name",
        description: String = "description",
        price: String = "price"
    ) -> Self {
        .init(
            id: id,
            groupName: groupName,
            name: name,
            description: description,
            price: price
        )
    }
}
#endif
