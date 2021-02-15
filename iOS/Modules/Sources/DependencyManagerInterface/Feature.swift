import Foundation
import SwiftUI

open class Feature {
    
    private static var dependenciesContainer: DependenciesContainerInterface?
    
    open class func  initialize(withContainer container: DependenciesContainerInterface) {
        guard dependenciesContainer == nil else {
            fatalError("The container should not be started twice!")
        }
        dependenciesContainer = container
    }
    
    open class func resolve<T>(
        _ dependencyType: T.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) -> T {
        guard let instance = container(file: file, line: line).get(dependencyType) else {
            fatalError(
                "You should register the dependency before trying to use it!",
                file: file,
                line: line
            )
        }
        return instance
    }
    
    open class func container(
        file: StaticString = #file,
        line: UInt = #line
    ) -> DependenciesContainerInterface {
        guard let containerInstance = dependenciesContainer else {
            fatalError(
                "You should initialize the feature with a container before using it!",
                file: file,
                line: line
            )
        }
        return containerInstance
    }
}
