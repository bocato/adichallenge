import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI
import SnapshotTesting
import XCTest
@testable import Feature_Products

/*
 Notes:
 - The tests were recorded on iPhone 11, with iOS 14.4
*/

final class ProductDetailsViewTests: XCTestCase {
    // MARK: - Properties

    private let isRecordModeEnabled = false
    private var mainQueueFake = DispatchQueue.testScheduler
    private lazy var environment: ProductDetailsEnvironment = .fixture(
        mainQueue: mainQueueFake.eraseToAnyScheduler()
    )
    private lazy var store: Store<ProductDetailsState, ProductDetailsAction> = {
        .init(
            initialState: .init(props: .fixture()),
            reducer: productDetailsReducer,
            environment: environment
        )
    }()
    private lazy var sut: ProductDetailsView = .init(store: store)
    private lazy var sutContainer: UINavigationController = {
        let hostingController: UIHostingController = .init(
            rootView: sut
        )
        hostingController.view.frame = UIScreen.main.bounds
        let navigationController: UINavigationController = .init(
            rootViewController: hostingController
        )
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    // MARK: - Tests
    
    func test_snapshot_loading() {
        // Given
        store = store.scope { state -> ProductDetailsState in
            return .init(
                props: .fixture(),
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
        store = store.scope { state -> ProductDetailsState in
            return .init(
                props: .fixture(),
                isLoading: false,
                apiError: nil,
                product: .fixture(
                    name: "My Product",
                    description: "Description description description description description description...",
                    price: "€ 1,23",
                    reviews: [
                        .fixture(
                            rating: "⭐️⭐️⭐️⭐️⭐️⭐️",
                            text: "Review review review review review review review review review review review..."),
                        .fixture(
                            rating: "⭐️⭐️⭐️⭐️⭐️⭐️",
                            text: "Review review review review review review review review review review review..."),
                        .fixture(
                            rating: "⭐️⭐️⭐️⭐️⭐️⭐️",
                            text: "Review review review review review review review review review review review..."),
                        .fixture(
                            rating: "⭐️⭐️⭐️⭐️⭐️⭐️",
                            text: "Review review review review review review review review review review review..."),
                        .fixture(
                            rating: "⭐️⭐️⭐️⭐️⭐️⭐️",
                            text: "Review review review review review review review review review review review..."),
                        .fixture(
                            rating: "⭐️⭐️⭐️⭐️⭐️⭐️",
                            text: "Review review review review review review review review review review review..."),
                    ]
                )
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
        store = store.scope { state -> ProductDetailsState in
            return .init(
                props: .fixture(),
                isLoading: false,
                apiError: .init(NSError(domain: "APIError", code: -1, userInfo: nil)), product: nil
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
        store = store.scope { state -> ProductDetailsState in
            return .init(
                props: .fixture(),
                isLoading: false,
                apiError: nil,
                product: nil
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
