import Foundation
@testable import DependencyManager
@testable import DependencyManagerInterface
import TestingToolkit
import XCTest

final class ModuleTests: XCTestCase {
    // MARK: - Properties
    
    private lazy var dependenciesContainerMock: DependenciesContainerMock = .init()
    
    // MARK: - Tests
    
    func test_init_shouldNotBeCalled() {
        // Given
        let sut = ModuleEntryPoint.self
        // When / Then
        expectFatalError(
            expectedMessage: "Init should not be called.",
            timeout: 0.5,
            testcase: { _ = sut.init() }
        )
    }
    
    func test_initialize_shouldSetDependenciesContainerInstance() {
        // Given
        let sut = ModuleEntryPoint.self
        sut.dependenciesContainer = nil
        // When
        sut.initialize(withContainer: dependenciesContainerMock)
        // Then
        XCTAssertNotNil(sut.dependenciesContainer)
    }
    
    func test_initialize_shouldNotBeCalledTwice() {
        // Given
        let sut = ModuleEntryPoint.self
        sut.initialize(withContainer: dependenciesContainerMock)
        // When / Then
        expectFatalError(
            expectedMessage: "The container should not be started twice!",
            timeout: 0.5,
            testcase: { sut.initialize(withContainer: self.dependenciesContainerMock) }
        )
    }
    
    func test_resolve_whenTryingToResolveAnUnregisteredDependency_itShouldThrowFatalError() {
        // Given
        let sut = ModuleEntryPoint.self
        sut.dependenciesContainer = nil
        sut.initialize(withContainer: dependenciesContainerMock)
        // When / Then
        expectFatalError(
            expectedMessage: "You should register the dependency before trying to use it!",
            timeout: 0.5,
            testcase: { _ = sut.resolve(SomeDependencyProtocol.self) }
        )
    }
    
    func test_resolve_whenTryingToResolveAnRegisteredDependency_itShouldReturnTheExpectedInstance() {
        // Given
        let myDependencyInstance: SomeDependencyObject = .init()
        dependenciesContainerMock.register(
            factory: { myDependencyInstance },
            forMetaType: SomeDependencyProtocol.self
        )

        let sut = ModuleEntryPoint.self
        sut.dependenciesContainer = nil
        sut.initialize(withContainer: dependenciesContainerMock)
        // When
        let resolvedInstance = sut.resolve(SomeDependencyProtocol.self)
        // Then
        XCTAssertTrue(resolvedInstance === myDependencyInstance)
    }
    
    func test_container_whenItWasNotInitialized_shouldThrowFatalError() {
        // Given
        let sut = ModuleEntryPoint.self
        sut.dependenciesContainer = nil
        // When / Then
        expectFatalError(
            expectedMessage: "You should initialize the module with a container before using it!",
            timeout: 0.5,
            testcase: { _ = sut.container() }
        )
    }
    
    func test_container_shouldReturnModuleContainer() {
        // Given
        let sut = ModuleEntryPoint.self
        sut.dependenciesContainer = nil
        let containerInstance: DependenciesContainerMock = .init()
        sut.initialize(withContainer: containerInstance)
        // When
        let moduleContainerInstance = sut.container()
        // Then
        XCTAssertTrue(containerInstance === moduleContainerInstance)
    }
}

// MARK: - Testing Helpers

private final class ModuleEntryPoint: Module {}
private protocol SomeDependencyProtocol: AnyObject {}
private final class SomeDependencyObject: SomeDependencyProtocol {}
