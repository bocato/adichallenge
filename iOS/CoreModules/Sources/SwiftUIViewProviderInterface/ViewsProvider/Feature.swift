import Foundation
import SwiftUI

/// Defines the entry point for a Feature Module.
/// Example:
/// ```
/// public struct ExampleFeature: Feature {
///     public static func buildView<Context, Environment>(
///         fromRoute route: ViewRoute?,
///         withContext context: Context,
///         environment: Environment
///     ) -> AnyCustomView {
///         switch (route, context, environment) {
///         case let (myRoute as MyViewRoute, context as MyViewContext, myEnvironment as MyEnvironment):
///             return MyView(
///                 route: myRoute,
///                 context: myContext,
///                 environment: myEnvironment
///             )
///             .eraseToAnyCustomView()
///          default:
///             // Here we normally return the feature's entry point, or the first screen of the most common flow.
///             return EmptyView()
///                 .eraseToAnyCustomView()
///         }
///     }
/// }
/// ```
public protocol Feature {
    /// Builds the view for some route, with a context and it's environment.
    /// - Parameters:
    ///   - route: a route, that describes a view, if `nil`will normally return the Main View for this feature.
    ///   - context: a some contextual data to be used on the view construction or when handling its route.
    ///   - environment: the environment for the view, which normally holds it's dependencies.
    static func buildView<Context, Environment>(
        fromRoute route: ViewRoute?,
        withContext context: Context,
        environment: Environment
    ) -> AnyCustomView
}
public extension Feature {
    /// Builds the view for some route, with a context and it's environment.
    /// - Parameters:
    ///   - route: a route, that describes a view, if `nil`will normally return the Main View for this feature.
    static func buildView(
        fromRoute route: ViewRoute?
    ) -> AnyCustomView {
        buildView(
            fromRoute: route,
            withContext: EmptyViewRouteContext(),
            environment: EmptyEnvironment()
        )
    }
    /// Builds the view for some route, with a context and it's environment.
    /// - Parameters:
    ///   - route: a route, that describes a view, if `nil`will normally return the Main View for this feature.
    ///   - context: a some contextual data to be used on the view construction or when handling its route.
    static func buildView<Context>(
        fromRoute route: ViewRoute?,
        withContext context: Context
    ) -> AnyCustomView {
        buildView(
            fromRoute: route,
            withContext: context,
            environment: EmptyEnvironment()
        )
    }

    /// Builds the view for some route, with a context and it's environment.
    /// - Parameters:
    ///   - route: a route, that describes a view, if `nil`will normally return the Main View for this feature.]
    ///   - environment: the environment for the view, which normally holds it's dependencies.
    static func buildView<Environment>(
        fromRoute route: ViewRoute?,
        environment: Environment
    ) -> AnyCustomView {
        buildView(
            fromRoute: route,
            withContext: EmptyViewRouteContext(),
            environment: environment
        )
    }
}
