import DependencyManagerInterface
import Foundation

/// The concrete implementation of a dependency store
public final class DependenciesContainer: DependenciesContainerInterface {
    // MARK: - Properties

    var dependencyInstances = NSMapTable<NSString, AnyStorableDependency>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory
    )

    var dependencyFactories = [String: DependencyFactory]()

    // MARK: - Initialization

    public init() {}

    // MARK: - Public API

    public func get<T>(_ arg: T.Type) -> T? {
        let name = String(describing: arg)
        let object = dependencyInstances.object(forKey: name as NSString)

        guard object == nil else {
            return object?.instance as? T
        }

        guard let factory: DependencyFactory = dependencyFactories[name] else {
            return nil
        }

        let newInstance = factory()
        let wrappedInstance = AnyStorableDependency(instance: newInstance)
        dependencyInstances.setObject(wrappedInstance, forKey: name as NSString)
        return newInstance as? T
    }

    public func register<T>(
        factory: @escaping DependencyFactory,
        forMetaType metaType: T.Type,
        failureHandler: (String) -> Void
    ) {
        let name = String(describing: metaType)
        guard dependencyFactories[name] == nil else {
            failureHandler("A dependency should never be registered twice!")
            return
        }
        dependencyFactories[name] = factory
    }
}

extension DependenciesContainer {
    // MARK: - Inner Types

    final class AnyStorableDependency {
        let instance: Any
        init(instance: Any) {
            self.instance = instance
        }
    }
}
