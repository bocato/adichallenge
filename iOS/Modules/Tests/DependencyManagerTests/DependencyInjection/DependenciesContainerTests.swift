import Foundation
@testable import SwiftUIViewProvider
import SwiftUIViewProviderInterface
import XCTest

final class DependenciesContainerTests: XCTestCase {
    // MARK: - Properties

    private let sut: DependenciesContainer = .init()

    // MARK: - Tests

    func test_get_whenTheDependencyWasNotRegistered_itShouldReturnNill() {
        // Given
        let metaType = DummyDependencyProtocol.self
        // When
        let returnedInstance = sut.get(metaType)
        // Then
        XCTAssertNil(returnedInstance)
    }

    func test_get_whenTheFactoryForADependencyIsRegistered_itShouldReturnTheRegisteredInstance() {
        // Given
        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self
        sut.register(
            factory: { instance },
            forMetaType: metaType
        )
        // When
        let returnedInstance = sut.get(metaType)
        // Then
        XCTAssertTrue(instance === returnedInstance)
    }

    func test_get_whenAFactoryIsRegistered_butTheDependencyWasNeverUsed_itShouldBeCreatedAndStoredInMemory() {
        // Given
        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self

        let dependencyFactoryCallExpectation = expectation(description: "The DependencyFactory was called.")
        var dependencyFactoryCalled = false
        let dependencyFactory: DependencyFactory = {
            dependencyFactoryCalled = true
            dependencyFactoryCallExpectation.fulfill()
            return instance
        }
        sut.register(
            factory: dependencyFactory,
            forMetaType: metaType
        )
        XCTAssertEqual(sut.dependencyInstances.count, 0)

        // When
        let returnedInstance = sut.get(metaType)

        // Then
        wait(for: [dependencyFactoryCallExpectation], timeout: 0.1)

        XCTAssertNotNil(returnedInstance)
        XCTAssertTrue(dependencyFactoryCalled)
        XCTAssertEqual(sut.dependencyInstances.count, 1)
    }

    func test_get_whenAFactoryIsRegistered_andTheDependencyWasAlreadyUsed_itShouldBeRetrievedFromMemory() {
        // Given
        sut.dependencyInstances = .init(
            keyOptions: .strongMemory,
            valueOptions: .strongMemory
        )
        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self

        let dependencyFactoryCallExpectation = expectation(description: "The DependencyFactory was called.")
        dependencyFactoryCallExpectation.expectedFulfillmentCount = 1
        var dependencyFactoryCallCount = 0
        let dependencyFactory: DependencyFactory = {
            dependencyFactoryCallCount += 1
            dependencyFactoryCallExpectation.fulfill()
            return instance
        }
        sut.register(
            factory: dependencyFactory,
            forMetaType: metaType
        )
        let firstReturnedInstance = sut.get(metaType)

        // When
        let secondReturnedInstance = sut.get(metaType)

        // Then
        wait(for: [dependencyFactoryCallExpectation], timeout: 0.1)

        XCTAssertTrue(firstReturnedInstance === secondReturnedInstance)
        XCTAssertEqual(sut.dependencyInstances.count, sut.dependencyFactories.count)
        XCTAssertEqual(dependencyFactoryCallCount, 1)
    }

    func test_register_whenAFactoryIsRegistered_itShouldBeStoredInMemory() {
        // Given
        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self
        let metaTypeKey = String(describing: metaType)

        // When
        sut.register(
            factory: { instance },
            forMetaType: metaType
        )

        // Then
        let memoryContainsFactoryForMetatype = sut.dependencyFactories.contains(where: { $0.key == metaTypeKey })
        XCTAssertTrue(memoryContainsFactoryForMetatype)
    }

    func test_register_whenADependencyFactoryIsRegisteredTwice_itShouldCallTheFailureHandlerWithTheExpectedMessage() {
        // Given
        let instance = DummyDependency()
        let metaType = DummyDependencyProtocol.self
        let dependencyFactory: DependencyFactory = { instance }
        let expectedFailureMessage = "A dependency should never be registered twice!"

        let failureExpectation = expectation(description: "The failureHandler was called.")
        var receivedFailureMessage: String?
        let failureHandler: (String) -> Void = { message in
            receivedFailureMessage = message
            failureExpectation.fulfill()
        }

        // When
        sut.register(
            factory: dependencyFactory,
            forMetaType: metaType,
            failureHandler: failureHandler
        )
        sut.register(
            factory: dependencyFactory,
            forMetaType: metaType,
            failureHandler: failureHandler
        )

        // Then
        wait(for: [failureExpectation], timeout: 0.1)

        XCTAssertEqual(expectedFailureMessage, receivedFailureMessage)
    }
}

// MARK: - Test Doubles

protocol DummyDependencyProtocol: AnyObject {
    func doSomething()
}

final class DummyDependency: DummyDependencyProtocol {
    func doSomething() {}
}
