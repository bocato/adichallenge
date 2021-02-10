import Foundation

/// Defines a route object which represents a path and data needed to be trasnformed into a view.
/// NOTE: This should be placed in some kind of interfaces/contracts module.
/// Example:
/// ```
/// public struct MyViewRoute: ViewRoute {
///     public static var identifier: String { "module:my_view" }
///     let someParameter: String
///
///     public init(
///         someParameter: String
///     ) {
///         self.someParameter = someParameter
///     }
/// }
/// ```
public protocol ViewRoute {
    static var identifier: String { get }
}
public extension ViewRoute {
    static var asAnyViewRouteType: AnyViewRouteType {
        .init(self)
    }
}

/// Type-Erased wrapper for `ViewRoute`
public final class AnyViewRouteType {
    public let metatype: Any
    public init<T: ViewRoute>(_ routeType: T.Type) {
        self.metatype = routeType
    }
}
