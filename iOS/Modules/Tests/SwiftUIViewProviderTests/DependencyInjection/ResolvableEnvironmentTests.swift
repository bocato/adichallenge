import Foundation
@testable import SwiftUIViewProvider
import SwiftUIViewProviderInterface
import XCTest

final class ResolvableEnvironmentTests: XCTestCase {
    // MARK: - Tests

    func test_initialize_shouldSetEnvironmentInstancesWithTheOnesFromTheContainer() {
        // Given
        let sut = ResolvableEnvironmentSubject()

        let container = DependenciesContainer()

        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self

        container.register(
            factory: { instance },
            forMetaType: metaType
        )

        // When
        sut.initialize(withContainer: container)

        // Then
        XCTAssertNotNil(sut.dummyDependency)
    }
}

// MARK: - Test Doubles

private struct ResolvableEnvironmentSubject: ResolvableEnvironment {
    @Dependency var dummyDependency: DummyDependencyProtocol
}
