import Foundation
import SwiftUI
import SwiftUIViewProviderInterface

public enum SwiftUIViewProviderError: Error {
    case unregisteredRouteForIdentifier(String)
}

public final class SwiftUIViewsProvider: SwiftUIViewsProviderInterface {
    // MARK: - Dependencies

    let container: DependenciesContainerInterface
    let unavailableViewBuilder: () -> AnyView

    // MARK: - Properties

    private(set) var registeredRoutes = [String: (AnyViewRouteType, FeatureRoutesHandler)]()

    // MARK: - Initialization

    public init(
        container: DependenciesContainerInterface? = nil,
        unavailableViewBuilder: @escaping () -> AnyView = { AnyView(EmptyView()) }
    ) {
        self.container = container ?? DependenciesContainer()
        self.unavailableViewBuilder = unavailableViewBuilder
        self.container.register(
            factory: { self },
            forMetaType: SwiftUIViewsProviderInterface.self
        )
    }

    // MARK: - Public API

    public func register<T>(
        dependencyFactory: @escaping DependencyFactory,
        forType metaType: T.Type
    ) {
        container.register(
            factory: dependencyFactory,
            forMetaType: metaType
        )
    }

    public func register(routesHandler: FeatureRoutesHandler) {
        routesHandler.routes.forEach {
            registeredRoutes[$0.identifier] = ($0.asAnyViewRouteType, routesHandler)
        }
    }

    public func hostingController<Environment>(
        withInitialFeature feature: Feature.Type,
        environment: Environment
    ) -> UIHostingController<AnyView> {
        if let resolvableEnvironment = environment as? ResolvableEnvironment {
            resolvableEnvironment.initialize(withContainer: container)
        }

        let rootView = feature.buildView(
            fromRoute: nil,
            withContext: EmptyViewRouteContext(),
            environment: environment
        )
        .eraseToAnyView()

        return UIHostingController(rootView: rootView)
    }

    public func rootView(for feature: Feature.Type) -> AnyCustomView {
        let rootView = feature.buildView(
            fromRoute: nil,
            withContext: EmptyViewRouteContext(),
            environment: ContainerAwareEnvironment(
                container: container
            )
        )
        return rootView
    }

    public func customViewForRoute<Environment, Context>(
        _ route: ViewRoute,
        withContext context: Context,
        environment: Environment
    ) -> AnyCustomView {
        guard let handler = handler(forRoute: route) else {
            return unavailableViewBuilder() // @TODO: Review this...
                .eraseToAnyCustomView()
        }

        if let resolvableEnvironment = environment as? ResolvableEnvironment {
            resolvableEnvironment.initialize(withContainer: container)
        }

        let feature = handler.destination(
            forRoute: route,
            withContext: context,
            environment: environment
        )

        let newView = feature.buildView(
            fromRoute: route,
            withContext: context,
            environment: environment
        )

        return newView
    }

    func handler(forRoute route: ViewRoute) -> FeatureRoutesHandler? {
        let routeIdentifier = type(of: route).identifier
        return registeredRoutes[routeIdentifier]?.1
    }
}

#if DEBUG
    public final class SwiftUIViewProviderDummy: SwiftUIViewsProviderInterface {
        public init() {}
        public func register<T>(dependencyFactory _: @escaping DependencyFactory, forType _: T.Type) {}
        public func register(routesHandler _: FeatureRoutesHandler) {}
        public func hostingController<Environment>(withInitialFeature _: Feature.Type, environment _: Environment) -> UIHostingController<AnyView> {
            .init(rootView: AnyView(EmptyView()))
        }

        public func rootView(for _: Feature.Type) -> AnyCustomView {
            .init(erasing: EmptyView())
        }

        public func anyViewForRoute<Environment, Context>(_: ViewRoute, withContext _: Context, environment _: Environment) -> AnyView {
            .init(EmptyView())
        }

        public func customViewForRoute<Environment, Context>(_: ViewRoute, withContext _: Context, environment _: Environment) -> AnyCustomView {
            .init(erasing: EmptyView())
        }
    }
#endif
