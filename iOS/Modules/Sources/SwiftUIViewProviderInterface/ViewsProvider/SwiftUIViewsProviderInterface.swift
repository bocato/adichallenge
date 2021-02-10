import Foundation
import SwiftUI

/// Represents an Empty context, to enable  ommiting context's when they are not needed.
public struct EmptyViewRouteContext {
    public init() {}
}

/// Represents an Empty environment, to enable  ommiting environments's when they are not needed.
public struct EmptyEnvironment {
    public init() {}
}

/// Defines a contract for the View's Factory related to routes/features.
/// Usage example:
/// ```
/// let viewsProvider: FeatureViewsProviding = SwiftUIViewsProvider.shared
/// let route: MyViewRoute = .init(
///     someParameter: "some value"
/// )
/// let context: MyViewContext = .init(
///     value: "some value"
/// )
/// let environment: MyEnvironment = .init(
///     someService: SomeService()
/// )
/// let myView = viewsProvider.customViewForRoute(
///     route,
///     withContext: context,
///     environment: environment
/// )
/// .eraseToAnyView()
/// ```
public protocol FeatureViewsProviding {
    /// Builds a `UIHostingController` with the Main View for the feature.
    /// - Parameters:
    ///   - feature: the feature you want to get a Main view from.
    ///   - environment: the initial environment for the feature.
    /// - Returns: A `UIHostingController` with the Main View as it's rootView .
    func hostingController<Environment>(
        withInitialFeature feature: Feature.Type,
        environment: Environment
    ) -> UIHostingController<AnyView>
    
    /// Builds an `AnyCustomView` with the Main View for the feature.
    /// - Parameters:
    ///   - feature: the feature you want to get a Main view from.
    /// - Returns: An `AnyCustomView`` with the Main View as it's rootView .
    func rootView(for feature: Feature.Type) -> AnyCustomView

    /// Builds a view wrapped by `AnyCustomView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    ///   - context: a context that can provide information for the view builder (Feature factory) or the RouteHandler.
    ///   - environment: an environment related to the View, that holds it's dependencies.
    /// - Returns: A view wrapped by `AnyCustomView`, related to the route provided.
    func customViewForRoute<Environment, Context>(
        _ route: ViewRoute,
        withContext context: Context,
        environment: Environment
    ) -> AnyCustomView
    
}
public extension FeatureViewsProviding {
    /// Builds a `UIHostingController` with the Main View for the feature.
    /// - Parameters:
    ///   - feature: the feature you want to get a Main view from.
    /// - Returns: A `UIHostingController` with the Main View as it's rootView .
    func hostingController(
        withInitialFeature feature: Feature.Type
    ) -> UIHostingController<AnyView> {
        self.hostingController(
            withInitialFeature: feature,
            environment: EmptyEnvironment()
        )
    }
}

public extension FeatureViewsProviding {
    /// Builds a view wrapped by `AnyView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    ///   - context: a context that can provide information for the view builder (Feature factory) or the RouteHandler.
    ///   - environment: an environment related to the View, that holds it's dependencies.
    /// - Returns: A view wrapped by `AnyView`, related to the route provided.
    func anyViewForRoute<Environment, Context>(
        _ route: ViewRoute,
        withContext context: Context,
        environment: Environment
    ) -> AnyView {
        customViewForRoute(
            route,
            withContext: context,
            environment: environment
        ).eraseToAnyView()
    }

    /// Builds a view wrapped by `AnyView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    ///   - context: a context that can provide information for the view builder (Feature factory) or the RouteHandler.
    /// - Returns: A view wrapped by `AnyView`, related to the route provided.
    func anyViewForRoute<Context>(
        _ route: ViewRoute,
        withContext context: Context
    ) -> AnyView {
        customViewForRoute(
            route,
            withContext: context
        )
        .eraseToAnyView()
    }

    /// Builds a view wrapped by `AnyView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    ///   - environment: an environment related to the View, that holds it's dependencies.
    /// - Returns: A view wrapped by `AnyView`, related to the route provided.
    func anyViewForRoute<Environment>(
        _ route: ViewRoute,
        environment: Environment
    ) -> AnyView {
        customViewForRoute(
            route,
            environment: environment
        )
        .eraseToAnyView()
    }

    /// Builds a view wrapped by `AnyView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    /// - Returns: A view wrapped by `AnyView`, related to the route provided.
    func anyViewForRoute(
        _ route: ViewRoute
    ) -> AnyView {
        customViewForRoute(route)
            .eraseToAnyView()
    }
}

public extension FeatureViewsProviding {
    /// Builds a view wrapped by `AnyCustomView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    ///   - context: a context that can provide information for the view builder (Feature factory) or the RouteHandler.
    /// - Returns: A view wrapped by `AnyCustomView`, related to the route provided.
    func customViewForRoute<Context>(
        _ route: ViewRoute,
        withContext context: Context
    ) -> AnyCustomView {
        self.customViewForRoute(
            route,
            withContext: context,
            environment: EmptyEnvironment()
        )
    }

    /// Builds a view wrapped by `AnyCustomView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    ///   - environment: an environment related to the View, that holds it's dependencies.
    /// - Returns: A view wrapped by `AnyCustomView`, related to the route provided.
    func customViewForRoute<Environment>(
        _ route: ViewRoute,
        environment: Environment
    ) -> AnyCustomView {
        self.customViewForRoute(
            route,
            withContext: EmptyViewRouteContext(),
            environment: environment
        )
    }

    /// Builds a view wrapped by `AnyCustomView` related to a route.
    /// - Parameters:
    ///   - route: a route to represent the view request.
    /// - Returns: A view wrapped by `AnyCustomView`, related to the route provided.
    func customViewForRoute(
        _ route: ViewRoute
    ) -> AnyCustomView {
        self.customViewForRoute(
            route,
            withContext: EmptyViewRouteContext(),
            environment: EmptyEnvironment()
        )
    }
}

public typealias SwiftUIViewsProviderInterface = FeatureDependenciesRegistering & FeatureViewsProviding
