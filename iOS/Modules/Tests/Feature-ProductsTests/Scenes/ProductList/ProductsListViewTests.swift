import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
@testable import Feature_Products
import FoundationKit
import RepositoryInterface
import SnapshotTesting
import SwiftUI
import XCTest

/*
 Notes:
 - The tests were recorded on iPhone 11, with iOS 14.4
 */

final class ProductsListViewTests: XCTestCase {
    // MARK: - Properties

    private let isRecordModeEnabled = false
    private var mainQueueFake = DispatchQueue.testScheduler
    private lazy var environment: ProductsListEnvironment = .fixture(
        mainQueue: mainQueueFake.eraseToAnyScheduler()
    )
    private lazy var store: Store<ProductsListState, ProductsListAction> = {
        .init(
            initialState: .init(),
            reducer: productsListReducer,
            environment: environment
        )
    }()

    private lazy var dependenciesContainerFake: DependenciesContainerFake = {
        let container: DependenciesContainerFake = .init()
        container.register(factory: ProductsRepositoryDummy.init, forMetaType: ProductsRepositoryProtocol.self)
        container.register(factory: ReviewsRepositoryDummy.init, forMetaType: ReviewsRepositoryProtocol.self)
        return container
    }()

    private let productDetailsViewBuilderStub: ProductDetailsViewBuilderStub = .init()
    private lazy var sut: ProductsListView = .init(
        container: dependenciesContainerFake,
        productDetailsViewBuilder: productDetailsViewBuilderStub,
        store: store
    )
    private lazy var sutContainer: UIHostingController<ProductsListView> = {
        let hostingController: UIHostingController = .init(
            rootView: sut
        )
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }()

    // MARK: - Tests

    func test_snapshot_loading() {
        // Given
        store = store.scope { _ -> ProductsListState in
            .init(
                isLoading: true
            )
        }
        // When
        _ = sutContainer.view
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }

    func test_snapshot_list() {
        // Given
        store = store.scope { _ -> ProductsListState in
            .init(
                isLoading: false,
                productRows: [
                    .fixture(id: "ID 1", name: "Product 1"),
                    .fixture(id: "ID 2", name: "Product 2"),
                    .fixture(id: "ID 3", name: "Product 3"),
                    .fixture(id: "ID 4", name: "Product 4"),
                ],
                productImageStates: [
                    "ID 1": .empty,
                    "ID 2": .empty,
                    "ID 3": .empty,
                    "ID 4": .empty,
                ]
            )
        }
        // When
        _ = sutContainer.view
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }

    func test_snapshot_filtering() {
        // Given
        store = store.scope { _ -> ProductsListState in
            .init(
                isLoading: false,
                searchInput: "AB",
                productRows: [
                    .fixture(),
                ],
                filteredProductRows: []
            )
        }
        // When
        _ = sutContainer.view
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }

    func test_snapshot_emptyFilterResults() {
        // Given
        store = store.scope { _ -> ProductsListState in
            .init(
                isLoading: false,
                searchInput: "ABCD",
                productRows: [
                    .fixture(),
                ],
                filteredProductRows: nil
            )
        }
        // When
        _ = sutContainer.view
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }

    func test_snapshot_apiError() {
        // Given
        store = store.scope { _ -> ProductsListState in
            .init(
                isLoading: false,
                apiError: .init(NSError(domain: "APIError", code: -1, userInfo: nil))
            )
        }
        // When
        _ = sutContainer.view
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }

    func test_snapshot_emptyAPIResponse() {
        // Given
        store = store.scope { _ -> ProductsListState in
            .init(
                isLoading: false,
                productRows: []
            )
        }
        // When
        _ = sutContainer.view
        // Then
        assertSnapshot(
            matching: sutContainer,
            as: .image,
            record: isRecordModeEnabled
        )
    }
}
