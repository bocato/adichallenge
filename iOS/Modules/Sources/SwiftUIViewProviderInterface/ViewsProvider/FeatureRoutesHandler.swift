import Foundation
import SwiftUI

/// Defines a handler to resove
/// Example:
/// ```
/// public struct MyFeatureRoutesHandler: FeatureRoutesHandler {
///     public var routes: [ViewRoute.Type] { // Here you need to register all the
///         [                                 // Routes that will be resolved by this Handler.
///             MyViewRoute.self
///         ]
///     }
///
///     public init() {}
///
///     public func destination<Context, Environment>( // Here is where you define any kind of validation
///         forRoute route: ViewRoute,                 // in order to return other versions of the feature,
///         withContext context: Context,              // or to simply link the Routes to the Feature.
///         environment: Environment
///     ) -> Feature.Type {
///         let isValidRoute = routes.contains(where: { $0.self == type(of: route) })
///         guard isValidRoute else {
///             preconditionFailure()
///         }
///         return MyFeature.self
///     }
/// }
/// ```
public protocol FeatureRoutesHandler {
    /// Describes the routes types this handler acepts.
    /// Here you need to "register" the routes this handler is responsible for.
    var routes: [ViewRoute.Type] { get }

    /// Returns the destination that the tripple (Route, Context, Environment) will return...
    /// Here is a good place to return a new version of a Feature, for example.
    /// - Parameters:
    ///   - route: some route
    ///   - context: a context
    ///   - environment: an environment for the view
    func destination<Context, Environment>(
        forRoute route: ViewRoute,
        withContext context: Context,
        environment: Environment
    ) -> Feature.Type
}
