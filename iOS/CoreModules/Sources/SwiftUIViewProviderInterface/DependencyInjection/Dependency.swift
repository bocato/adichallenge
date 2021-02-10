import Foundation

/// Defines an interface for instances that can be resolved from a container
public protocol Resolvable {
    /// Resolves an instance using a container.
    /// - Parameter container: the dependencies container that stores that instance
    func resolve(withContainer container: DependenciesContainerInterface)
}

/// Defines a failure handler for a dependency resolver, which returns the failure reason as a String
public typealias DependencyResolverFailureHandler = (String) -> Void

/// Defines a resolvable dependency, which is able to resolve itself using a store.
@propertyWrapper
public final class Dependency<T>: Resolvable {
    // MARK: - Dependencies

    private let failureHandler: DependencyResolverFailureHandler

    // MARK: - Properties

    private(set) var resolvedValue: T!
    public var wrappedValue: T {
        if resolvedValue == nil {
            failureHandler("Check if you registered ")
        }
        return resolvedValue
    }

    // MARK: - Initialization

    required init(
        resolvedValue: T?,
        failureHandler: @escaping DependencyResolverFailureHandler = { msg in preconditionFailure(msg) }
    ) {
        self.resolvedValue = resolvedValue
        self.failureHandler = failureHandler
    }

    public convenience init() {
        self.init(resolvedValue: nil)
    }

    public static func resolvedValue(_ resolvedValue: T) -> Self {
        .init(
            resolvedValue: resolvedValue
        )
    }

    // MARK: - Public API

    public func resolve(withContainer container: DependenciesContainerInterface) {
        guard resolvedValue == nil else {
            failureHandler("Attempted to resolve \(type(of: self)) twice!")
            return
        }
        guard let value = container.get(T.self) else {
            failureHandler("Attempted to resolve \(type(of: self)), but there's nothing registered for this type.")
            return
        }
        resolvedValue = value
    }
}
