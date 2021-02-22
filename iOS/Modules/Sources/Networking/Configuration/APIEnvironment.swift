import Foundation
import NetworkingInterface

/// Defines a single instance for the EnvironmentProvider
public final class APIEnvironment: APIEnvironmentProvider {
    // MARK: - Dependencies

    private let baseURLProvider: BaseURLProviding

    // MARK: - Public Properties

    /// Defines the current enviroment
    public var currentEnvironment: APIEnvironmentIdentifier // TODO: Observe this, to notify environment changes, when needed.

    // MARK: - Initialization

    public init(
        currentEnvironment: APIEnvironmentIdentifier,
        baseURLProvider: BaseURLProviding
    ) {
        self.currentEnvironment = currentEnvironment
        self.baseURLProvider = baseURLProvider
    }

    // MARK: - Public API

    public func baseURL<Endpoint>(
        forEndpoint endpoint: Endpoint,
        file: StaticString,
        line: UInt
    ) -> URL {
        guard let url = baseURLProvider.baseURL(for: endpoint, environment: currentEnvironment) else {
            fatalError(
                "There are no requests without a baseURL, it must be set!",
                file: file,
                line: line
            )
        }
        return url
    }
}
