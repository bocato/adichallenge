import Foundation
import NetworkingInterface

private var dependenciesHolder: RepositoryModule.Dependencies?

public enum RepositoryModule {
    public struct Dependencies {
        let apiEnvironment: APIEnvironmentProvider
        let baseURLProvider: BaseURLProviding

        public init(
            apiEnvironment: APIEnvironmentProvider,
            baseURLProvider: BaseURLProviding? = nil
        ) {
            self.apiEnvironment = apiEnvironment
            self.baseURLProvider = baseURLProvider ?? DefaultBaseURLProvider()
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
