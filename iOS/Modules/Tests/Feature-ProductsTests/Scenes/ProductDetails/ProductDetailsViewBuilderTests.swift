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

final class ProductDetailsViewBuilderTests: XCTestCase {
    // MARK: - Tests
    
    func test_build_shouldResolveAllEnvironmentDependenciesWithContainer() {
        // Given
        let sut: ProductDetailsViewBuilder = .init()
        let dependenciesContainerMock: DependenciesContainerMock = .init()
        dependenciesContainerMock.register(
            factory: ProductsRepositoryDummy.init,
            forMetaType: ProductsRepositoryProtocol.self
        )
        dependenciesContainerMock.register(
            factory: ImagesRepositoryDummy.init,
            forMetaType: ImagesRepositoryProtocol.self
        )
        dependenciesContainerMock.register(
            factory: ReviewsRepositoryDummy.init,
            forMetaType: ReviewsRepositoryProtocol.self
        )
        // When
        _ = sut.build(
            productName: "productName",
            productID: "productID",
            container: dependenciesContainerMock
        )
        // Then
        XCTAssertEqual(dependenciesContainerMock.getCallCount, 3)
    }
}
