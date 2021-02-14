//import ComposableArchitecture
//import CoreUI
//import FoundationKit
//import SwiftUI
//import SnapshotTesting
//import XCTest
//@testable import Feature_Products
//
///*
// Notes:
// - The tests were recorded on iPhone 11, with iOS 14.2
//*/
//
//final class ProductsListViewTests: XCTestCase {
//    // MARK: - Properties
//
//    private let isRecordModeEnabled = false
//    private var environment: ProductsListEnvironment = .fixture()
//    private lazy var store: Store<ProductsListState, ProductsListAction> = {
//        .init(
//            initialState: .init(),
//            reducer: productsListReducer,
//            environment: environment
//        )
//    }()
//    private lazy var sut: ProductsListView = .init(store: store)
//    private lazy var sutContainer: UINavigationController = {
//        let host: UIHostingController = .init(rootView: sut)
//        host.view.frame = UIScreen.main.bounds
//        let navigationController = UINavigationController(rootViewController: host)
//        navigationController.navigationBar.prefersLargeTitles = true
//        return navigationController
//    }()
//
//    // MARK: - Tests
//
//    func test_snapshot_loadingData() {
//        // Given
//        store.scope { state -> ProductsListState in
//            return .init(
//                isLoading: true
//            )
//        }
//        // When
//        _ = sutContainer.view
//        // Then
//        assertSnapshot(
//            matching: sutContainer,
//            as: .image,
//            record: isRecordModeEnabled
//        )
//    }
//
////    // MARK: - Helpers
////
////    private func buildSUT() -> ObjectivesListView {
////
////    }
//}
