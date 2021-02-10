import Foundation
import SwiftUIViewProviderInterface

/// Marks an environment as Resolvable, i.e. tells the ViewFactory that it has
/// @Dependency properties that need to be resolved by a DependenciesContainer.
extension ResolvableEnvironment {
    func initialize(withContainer container: DependenciesContainerInterface) {
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            if let resolvableChild = child.value as? Resolvable {
                resolvableChild.resolve(withContainer: container)
            }
        }
    }
}