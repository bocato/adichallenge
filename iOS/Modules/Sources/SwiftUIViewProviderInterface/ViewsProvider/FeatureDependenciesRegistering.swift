import Foundation

/// Defines a contract 
public protocol FeatureDependenciesRegistering {
    /// Registers a factory for some dependency, related to it's interface/contract.
    /// - Parameters:
    ///   - dependencyFactory: a closure that build's some dependency.
    ///   - metaType: the interface/contract for the dependency.
    func register<T>(
        dependencyFactory: @escaping DependencyFactory,
        forType metaType: T.Type
    )

    /// Register a handler for the routes of some feature.
    /// - Parameter routesHandler: the handler for the faeture routes.
    func register(routesHandler: FeatureRoutesHandler)
}
