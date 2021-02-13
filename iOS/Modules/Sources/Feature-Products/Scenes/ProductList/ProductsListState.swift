import Foundation
import RepositoryInterface
import FoundationKit

struct ProductsListState: Equatable {
    var isLoading: Bool = false
    var apiError: EquatableErrorWrapper?
    var searchInput: String = ""
    var productRows: [ProductRowData] = []
    var filteredProductRows: [ProductRowData] = []
    var productImageStates: [String: LoadingState<Data>] = [:]
    var selectedProductID: String?
}
extension ProductsListState {
    var isFiltering: Bool { searchInput.count > 0 }
    var showFilteringView: Bool { searchInput.count > 0 && searchInput.count < 3 }
    var showEmptyFilterResults: Bool { searchInput.count >= 3 && filteredProductRows.isEmpty }
}

// MARK: - View Data Models

struct ProductRowData: Identifiable, Equatable {
    let id: String
    let groupName: String
    let name: String
    let description: String
    let price: String // formatted
}
