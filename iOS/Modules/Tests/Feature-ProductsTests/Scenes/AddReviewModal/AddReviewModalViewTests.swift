import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
@testable import Feature_Products
import FoundationKit
import SnapshotTesting
import SwiftUI
import XCTest

/*
 Notes:
 - The tests were recorded on iPhone 11, with iOS 14.4
 */

// TODO: Check why `RoundedRectangle` is with weird side lines on the snapshots and normal on the simmulator.. 🧐
final class AddReviewModalViewViewTests: XCTestCase {
    // MARK: - Properties

    private let isRecordModeEnabled = false
    private var mainQueueFake = DispatchQueue.testScheduler
    private lazy var environment: AddReviewModalEnvironment = .fixture(
        mainQueue: mainQueueFake.eraseToAnyScheduler()
    )
    private lazy var store: Store<AddReviewModalState, AddReviewModalAction> = {
        .init(
            initialState: .init(props: .fixture()),
            reducer: addReviewModalReducer,
            environment: environment
        )
    }()

    private lazy var sut: AddReviewModalView = .init(
        store: store
    )
    private lazy var sutContainer: UIViewController = {
        let hostingController: UIHostingController = .init(
            rootView: sut
        )
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }()

    // MARK: - Tests

    func test_snapshot_loading() {
        // Given
        store = store.scope { _ -> AddReviewModalState in
            .init(
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

    func test_snapshot_emptyInputs() {
        // Given
        store = store.scope { _ -> AddReviewModalState in
            .init(
                props: .fixture(),
                isLoading: false
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

    func test_snapshot_filledInputs() {
        // Given
        store = store.scope { _ -> AddReviewModalState in
            .init(
                props: .fixture(),
                isLoading: false,
                rating: 3,
                reviewText: "ReviewText reviewText\n  ReviewText reviewText\n ReviewText reviewText ReviewText reviewText\n ReviewText reviewText\nReviewText reviewText"
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
