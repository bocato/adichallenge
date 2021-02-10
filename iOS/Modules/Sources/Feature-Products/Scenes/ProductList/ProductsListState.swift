import Foundation
import RepositoryInterface

struct ProductsListState: Equatable {
    var isLoading: Bool = false
    var searchTerm: String = ""
    var productRows: [ProductRowData] = [
        .init(id: "ID 1", groupName: "Group 1", name: "Name 1", description: "Description 1", price: "$10.00")
    ]
}

// MARK: - View Data Models

struct ProductRowData: Identifiable, Equatable {
    let id: String
    let groupName: String
    let name: String
    let description: String
    let price: String // formatted
}
