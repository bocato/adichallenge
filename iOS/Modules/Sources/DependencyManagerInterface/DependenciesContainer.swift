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
    public func get<T>(_: T.Type) -> T? { nil }
    public func register<T>(
        factory _: @escaping DependencyFactory,
        forMetaType _: T.Type,
        failureHandler _: (String) -> Void
    ) {}
}

public final class DependenciesContainerMock: DependenciesContainerInterface {
    public var dependencyInstances: [String: Any]
    public init(
        dependencyInstances: [String: Any] = [:]
    ) {
        self.dependencyInstances = dependencyInstances
    }
    
    public private(set) var getCallCount = 0
    public func get<T>(_ metaType: T.Type) -> T? {
        getCallCount += 1
        let name = String(describing: metaType)
        let typeErasedInstance = dependencyInstances[name]
        let typeCastedInstance = typeErasedInstance as? T
        return typeCastedInstance
    }
    
    public private(set) var registerCallCount = 0
    public func register<T>(
        factory factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        failureHandler _: (String) -> Void
    ) {
        registerCallCount += 1
        let name = String(describing: metaType)
        dependencyInstances[name] = factory()
    }
}
#endif
