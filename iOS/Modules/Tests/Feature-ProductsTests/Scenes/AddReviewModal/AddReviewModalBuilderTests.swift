import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import RepositoryInterface
import Repository
@testable import Feature_Products
import FoundationKit
import SnapshotTesting
import SwiftUI
import XCTest

final class AddReviewModalBuilderTests: XCTestCase {
    // MARK: - Tests
    
    func test_build_shouldResolveAllEnvironmentDependenciesWithContainer() {
        // Given
        let sut: AddReviewModalBuilder = .init()
        let dependenciesContainerMock: DependenciesContainerMock = .init()
        dependenciesContainerMock.register(
            factory: ReviewsRepositoryDummy.init,
            forMetaType: ReviewsRepositoryProtocol.self
        )
        // When
        _ = sut.build(
            onDismiss: { _ in false },
            productID: "productID",
            container: dependenciesContainerMock
        )
        // Then
        XCTAssertEqual(dependenciesContainerMock.getCallCount, 1)
    }
}
