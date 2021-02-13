import Foundation
import RepositoryInterface
import FoundationKit

struct ProductsListState: Equatable {
    var isLoading: Bool = false
    var apiError: EquatableErrorWrapper?
    var searchTerm: String = ""
    var productRows: [ProductRowData] = []
    var productImageStates: [String: LoadingState<Data>] = [:]
    var selectedProductID: String?
}

// MARK: - View Data Models

struct ProductRowData: Identifiable, Equatable {
    let id: String
    let groupName: String
    let name: String
    let description: String
    let price: String // formatted
}
