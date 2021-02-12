import Foundation
import RepositoryInterface
import FoundationKit

struct ProductsListState: Equatable {
    var isLoading: Bool = false
    var viewState: ViewState
    var searchTerm: String = ""
    var productRows: [ProductRowData] = []
    var productImageStates: [String: LoadingState<Data>] = [:]
}

// MARK: - View Data Models

struct ProductRowData: Identifiable, Equatable {
    let id: String
    let groupName: String
    let name: String
    let description: String
    let price: String // formatted
}

// TODO: CREATE ERROR VIEW WITH RETRY BUTTON -> WARREN
