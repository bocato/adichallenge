import Foundation

/// Defines a factory that builds a dependency
public typealias DependencyFactory = () -> Any

/// Defines a contract for a dependency container
public protocol DependenciesContainerInterface: AnyObject {
    /// Get's a dependency from the container
    /// - Parameter arg: the type of the dependency
    func get<T>(_ arg: T.Type) -> T?

    /// Registers a dependency for the given type
    /// - Parameters:
    ///   - factory: a dependency factory
    ///   - metaType: the dependency metatype
    ///   - failureHandler: a handler to tells us that the dependency registration failed for some reason
    func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        failureHandler: (String) -> Void
    )
    #if DEBUG
        /// Enables uns to swap a factory for a given metatype, if needed.
        /// - Parameters:
        ///   - metaType: the dependency metatype
        ///   - newFactory: a new dependency factory
        func swapFactory<T>(forMetaType metaType: T.Type, to newFactory: @escaping DependencyFactory)
    #endif
}

public extension DependenciesContainerInterface {
    /// Registers a dependency for the given type
    /// - Parameters:
    ///   - factory: a dependency factory
    ///   - metaType: the dependency metatype
    func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type
    ) {
        register(
            factory: factory,
            forMetaType: metaType,
            failureHandler: { preconditionFailure($0) }
        )
    }
}
