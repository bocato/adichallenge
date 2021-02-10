@testable import SwiftUIViewProvider
import SwiftUIViewProviderInterface
import SwiftUI
import TestHelpers
import XCTest

final class SwiftUIViewsProviderTests: XCTestCase {
    // MARK: - Properties

    private let dependenciesContainer: DependenciesContainer = .init()
    private let featureRoutesHandlerFake: FeatureRoutesHandlerFake = .init()
    private lazy var sut: SwiftUIViewsProvider = {
        let instance: SwiftUIViewsProvider = .init(container: dependenciesContainer)
        return instance
    }()

    // MARK: - Tests

    func test_init_whenAContainerIsNotSet_itShouldBeConfiguredWithTheSharedInstance() {
        // Given / When
        let sut: SwiftUIViewsProvider = .init(container: nil)
        // Then
        let usesSharedContainer = sut.container === DependenciesContainer.shared
        XCTAssertTrue(usesSharedContainer)
    }

    func test_registerDependencyFactory_shouldAddItToDependenciesContainer() {
        // Given
        let dependency = DummyDependency()
        let metaType = DummyDependencyProtocol.self
        // When
        sut.register(
            dependencyFactory: { dependency },
            forType: metaType
        )
        // Then
        let metaTypeKey = String(describing: metaType)
        let containsDependencyFactory = dependenciesContainer.dependencyFactories.contains(where: { $0.key == metaTypeKey })
        XCTAssertTrue(containsDependencyFactory)
    }

    func test_registerRoutesHandler_shouldRegisterAllHandler_routeType_tuples() {
        // Given
        let dummyViewRouteType = ViewRouteDummy.self
        featureRoutesHandlerFake.routesToBeReturned = [dummyViewRouteType]
        // When
        sut.register(routesHandler: featureRoutesHandlerFake)
        // Then
        let containsHandlerRoutes = sut.registeredRoutes.contains(where: { $0.key == dummyViewRouteType.identifier })
        XCTAssertTrue(containsHandlerRoutes)
    }

    func test_hostingControllerWithInitialFeature_shouldReturnTheFeatureEntryPointView_andReceiveANilRoute() {
        // Given
        let viewToBeReturned = AnyCustomView(erasing: EmptyView())
        TestFeatureFake.viewToBeReturned = viewToBeReturned

        // When
        let hostingViewController = sut.hostingController(
            withInitialFeature: TestFeatureFake.self
        )

        // Then
        XCTAssertEqual(
            String(describing: hostingViewController.rootView),
            String(describing: viewToBeReturned.eraseToAnyView())
        )
        XCTAssertNil(TestFeatureFake.routePassed)
    }

    func test_hostingControllerWithInitialFeature_whenAnEnvironmentIsNotProvided_itShouldReceiveAnEmptyEnvironment() {
        // When
        _ = sut.hostingController(
            withInitialFeature: TestFeatureFake.self
        )

        // Then
        XCTAssertTrue(TestFeatureFake.environmentPassed is EmptyEnvironment)
    }

    func test_customViewForRoute_whenAnEnvironmentIsNotProvided_itShouldReceiveAnEmptyEnvironment() {
        // Given
        featureRoutesHandlerFake.routesToBeReturned = [ViewRouteDummy.self]
        featureRoutesHandlerFake.featureToBeReturned = TestFeatureFake.self
        sut.register(routesHandler: featureRoutesHandlerFake)

        let route = ViewRouteDummy()
        let context = ContextDummy()

        // When
        _ = sut.customViewForRoute(route, withContext: context)

        // Then
        XCTAssertNotNil(TestFeatureFake.environmentPassed)
        XCTAssertTrue(TestFeatureFake.environmentPassed is EmptyEnvironment)
    }

    func test_customViewForRoute_whenAContextIsNotProvided_itShouldReceiveAnEmptyContext() {
        // Given
        sut.register(routesHandler: featureRoutesHandlerFake)

        let route = ViewRouteDummy()
        let environment = EnvironmentDummy()

        // When
        _ = sut.customViewForRoute(route, environment: environment)

        // Then
        XCTAssertNotNil(featureRoutesHandlerFake.contextPassed)
        XCTAssertTrue(featureRoutesHandlerFake.contextPassed is EmptyViewRouteContext)
    }

    func test_customViewForRoute_whenEvironmentAndContextAreNotProvided_itShouldReceiveAnEmptyEnvironmentAndContext() {
        // Given
        featureRoutesHandlerFake.routesToBeReturned = [ViewRouteDummy.self]
        featureRoutesHandlerFake.featureToBeReturned = TestFeatureFake.self
        sut.register(routesHandler: featureRoutesHandlerFake)

        let route = ViewRouteDummy()

        // When
        _ = sut.customViewForRoute(route)

        // Then
        XCTAssertNotNil(TestFeatureFake.environmentPassed)
        XCTAssertTrue(TestFeatureFake.environmentPassed is EmptyEnvironment)

        XCTAssertNotNil(featureRoutesHandlerFake.contextPassed)
        XCTAssertTrue(featureRoutesHandlerFake.contextPassed is EmptyViewRouteContext)
    }

    func test_customViewForRoute_whenAHandlerIsNotFound_itShouldCallUnavailableViewBuilder() {
        // Given
        let unavailableViewBuilderCalledExpectation = expectation(description: "The Unavailable View builder was called.")
        var unavailableViewBuilderWasCalled = false
        let unavailableViewBuilder: () -> AnyView = {
            unavailableViewBuilderWasCalled = true
            unavailableViewBuilderCalledExpectation.fulfill()
            return AnyView(EmptyView())
        }

        let sut: SwiftUIViewProvider = .init(
            container: dependenciesContainer,
            unavailableViewBuilder: unavailableViewBuilder
        )
        let route = ViewRouteDummy()

        // When
        _ = sut.customViewForRoute(route)

        // Then
        wait(for: [unavailableViewBuilderCalledExpectation], timeout: 0.1)
        XCTAssertTrue(unavailableViewBuilderWasCalled)
    }

    func test_customViewForRoute_whenAnEnvironmentIsResolvable_itShouldBeResolved() {
        // Given
        let dependencyFactoryCalledExpectation = expectation(description: "The dependency factory was called.")
        var dependencyFactoryWasCalled = false
        let dependencyFactory: DependencyFactory = {
            dependencyFactoryWasCalled = true
            dependencyFactoryCalledExpectation.fulfill()
            return DummyDependency()
        }

        dependenciesContainer.register(
            factory: dependencyFactory,
            forMetaType: DummyDependencyProtocol.self
        )

        let featureRoutesHandlerFake: FeatureRoutesHandlerFake = .init()
        featureRoutesHandlerFake.routesToBeReturned = [ViewRouteDummy.self]
        featureRoutesHandlerFake.featureToBeReturned = TestFeatureFake.self
        sut.register(routesHandler: featureRoutesHandlerFake)

        let resolvableEnvironment = ResolvableEnvironmentMock()
        let route = ViewRouteDummy()

        // When
        _ = sut.customViewForRoute(route, environment: resolvableEnvironment)

        // Then
        wait(for: [dependencyFactoryCalledExpectation], timeout: 0.1)
        XCTAssertTrue(dependencyFactoryWasCalled)
    }

    func test_customViewForRoute_whenWeHaveValidRouteContextAndEnvironment_itShouldReturnTheExpectedView() {
        // Given
        let viewToBeReturned = EmptyView().eraseToAnyCustomView()
        TestFeatureFake.viewToBeReturned = viewToBeReturned

        let featureRoutesHandlerFake: FeatureRoutesHandlerFake = .init()
        featureRoutesHandlerFake.routesToBeReturned = [ViewRouteDummy.self]
        featureRoutesHandlerFake.featureToBeReturned = TestFeatureFake.self
        sut.register(routesHandler: featureRoutesHandlerFake)

        let route = ViewRouteDummy()
        let context = ContextDummy()
        let environment = EnvironmentDummy()

        // When
        let viewReturned = sut.customViewForRoute(
            route,
            withContext: context,
            environment: environment
        )

        // Then
        XCTAssertNotNil(TestFeatureFake.routePassed)
        XCTAssertTrue(TestFeatureFake.routePassed is ViewRouteDummy)

        XCTAssertNotNil(featureRoutesHandlerFake.contextPassed)
        XCTAssertTrue(featureRoutesHandlerFake.contextPassed is ContextDummy)

        XCTAssertNotNil(TestFeatureFake.environmentPassed)
        XCTAssertTrue(TestFeatureFake.environmentPassed is EnvironmentDummy)

        XCTAssertEqual(
            String(describing: viewReturned),
            String(describing: viewToBeReturned)
        )
    }
}

// MARK: - Test Doubles

struct ViewRouteDummy: ViewRoute {
    static var identifier: String { "ViewRouteDummy" }
}

struct EnvironmentDummy {}

struct ResolvableEnvironmentMock: ResolvableEnvironment {
    @Dependency var dummyDependency: DummyDependencyProtocol
}

struct ContextDummy {}

struct FeatureDummy: Feature {
    static func buildView<Context, Environment>(fromRoute route: ViewRoute?, withContext context: Context, environment: Environment) -> AnyCustomView {
        .init(erasing: EmptyView())
    }
}

final class TestFeatureFake: Feature {
    static var viewToBeReturned: AnyCustomView = EmptyView().eraseToAnyCustomView()
    private(set) static  var routePassed: ViewRoute?
    private(set) static var contextPassed: Any?
    private(set) static var environmentPassed: Any?
    static func buildView<Context, Environment>(
        fromRoute route: ViewRoute?,
        withContext context: Context,
        environment: Environment
    ) -> AnyCustomView {
        routePassed = route
        contextPassed = context
        environmentPassed = environment
        return viewToBeReturned
    }
}

final class FeatureRoutesHandlerFake: FeatureRoutesHandler {
    private(set) var routesCalled = false
    var routesToBeReturned: [ViewRoute.Type] = [ViewRouteDummy.self]
    var routes: [ViewRoute.Type] {
        routesCalled = true
        return routesToBeReturned
    }

    private(set) var destinationCalled = false
    private(set) var routePassed: ViewRoute?
    private(set) var contextPassed: Any?
    private(set) var environmentPassed: Any?
    var featureToBeReturned: Feature.Type = FeatureDummy.self
    func destination<Context, Environment>(
        forRoute route: ViewRoute,
        withContext context: Context,
        environment: Environment
    ) -> Feature.Type {
        routePassed = route
        contextPassed = context
        environmentPassed = environment
        return featureToBeReturned
    }
}
