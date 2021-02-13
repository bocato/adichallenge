import Foundation
import NetworkingInterface

private var dependenciesHolder: RepositoryModule.Dependencies?

public enum RepositoryModule {
    public struct Dependencies {
        let apiEnvironment: APIEnvironmentProvider

        public init(apiEnvironment: APIEnvironmentProvider) {
            self.apiEnvironment = apiEnvironment
        }
    }

    public static func registerDependencies(_ dependencies: Dependencies) {
        dependenciesHolder = dependencies
    }

    static func dependencies(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Dependencies {
        guard let dependencies = dependenciesHolder else {
            fatalError(
                "You should register the modules dependencies before using it!",
                file: file,
                line: line
            )
        }
        return dependencies
    }
}
