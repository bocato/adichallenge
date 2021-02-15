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

#if DEBUG
public final class DependenciesContainerDummy: DependenciesContainerInterface {
    public init() {}
    public func get<T>(_ arg: T.Type) -> T? { nil }
    public func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        failureHandler: (String) -> Void
    ) {}
}
#endif
