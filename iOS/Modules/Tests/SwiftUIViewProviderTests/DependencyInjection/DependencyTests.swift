import Foundation
@testable import SwiftUIViewProvider
@testable import SwiftUIViewProviderInterface
import TestHelpers
import XCTest

final class DependencyTests: XCTestCase {
    // MARK: - Tests

    func test_resolvedValue_shouldInitWithValidInstance() {
        // Given
        let instance = DummyDependency()
        // When
        let sut: Dependency<DummyDependencyProtocol> = .resolvedValue(instance)
        // Then
        XCTAssertNotNil(sut.resolvedValue)
    }

    func test_resolve_shouldCrash_whenResolvedTwice() {
        // Given
        let container = DependenciesContainer()
        container.register(
            factory: { DummyDependency() },
            forMetaType: DummyDependencyProtocol.self
        )

        let failureHandlerCalledExpectation = expectation(description: "The failureHandler was called.")
        var failureHandlerCalled = false
        let failureHandler: DependencyResolverFailureHandler = { _ in
            failureHandlerCalled = true
            failureHandlerCalledExpectation.fulfill()
        }
        let sut: Dependency<DummyDependencyProtocol> = .init(
            resolvedValue: nil,
            globalContainer: container,
            failureHandler: failureHandler
        )

        // When
        sut.resolve(withContainer: container)
        sut.resolve(withContainer: container)

        // Then
        wait(for: [failureHandlerCalledExpectation], timeout: 0.1)
        XCTAssertTrue(failureHandlerCalled)
    }

    func test_resolve_shouldCrash_whenTheDependencyWasNotRegistred() {
        // Given
        let container = DependenciesContainer()

        let failureHandlerCalledExpectation = expectation(description: "The failureHandler was called.")
        var failureHandlerCalled = false
        let failureHandler: DependencyResolverFailureHandler = { _ in
            failureHandlerCalled = true
            failureHandlerCalledExpectation.fulfill()
        }
        let sut: Dependency<DummyDependencyProtocol> = .init(
            resolvedValue: nil,
            globalContainer: container,
            failureHandler: failureHandler
        )

        // When
        sut.resolve(withContainer: container)

        // Then
        wait(for: [failureHandlerCalledExpectation], timeout: 0.1)
        XCTAssertTrue(failureHandlerCalled)
    }

    func test_wrappedValue_shouldCallContainer_whenResolvedValueIsNil() {
        // Given
        let containerMock: DependencieContainerMock = .init()
        let dependencyInstance = DummyDependency()
        containerMock.valueToBeReturned = dependencyInstance

        let sut: Dependency<DummyDependencyProtocol> = .init(
            resolvedValue: nil,
            globalContainer: containerMock
        )

        // When
        let returnedValue = sut.wrappedValue

        // Then
        XCTAssertTrue(containerMock.getCalled)
        XCTAssertTrue(dependencyInstance === returnedValue)
    }

    func test_wrappedValue_shouldNotCallContainer_whenTheResolvedValueIsNotNil() {
        // Given
        let resolvedValue = DummyDependency()
        let containerMock: DependencieContainerMock = .init()

        let sut: Dependency<DummyDependencyProtocol> = .init(
            resolvedValue: resolvedValue,
            globalContainer: containerMock
        )

        // When
        _ = sut.wrappedValue

        // Then
        XCTAssertFalse(containerMock.getCalled)
    }
}

// MARK: - Test Doubles

private final class DependencieContainerMock: DependenciesContainerInterface {
    var valueToBeReturned: Any?
    private(set) var getCalled = false
    func get<T>(_: T.Type) -> T? {
        getCalled = true
        return valueToBeReturned as? T
    }

    func register<T>(
        factory _: @escaping DependencyFactory,
        forMetaType _: T.Type,
        failureHandler _: (String) -> Void
    ) {}

    #if DEBUG
        func swapFactory<T>(forMetaType _: T.Type, to _: @escaping DependencyFactory) {}
    #endif
}
