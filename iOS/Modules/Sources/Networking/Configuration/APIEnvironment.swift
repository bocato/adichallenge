import Foundation
import NetworkingInterface

/// Defines a single instance for the EnvironmentProvider
/// NOTE: Simplified implementation, that could be extendend.
// TODO: Review this, maybe... Convert to singleton +? Add initialization from Application Container?
public final class APIEnvironment: APIEnvironmentProvider {
    // MARK: - Singleton

    public private(set) static var shared = APIEnvironment(
        currentEnvironment: .development,
        baseURL: URL(string: "http://localhost:3001")
    )

    // MARK: - Private Properties

    private var _baseURL: URL?

    // MARK: - Public Properties

    /// Defines the current enviroment
    public var currentEnvironment: APIEnvironmentType // TODO: Observe this, to notify environment changes

    /// Provides de base URL for the services
    public var baseURL: URL {
        guard let url = _baseURL else {
            fatalError("There are no requests without a baseURL, it must be set!")
        }
        return url
    }

    // MARK: - Initialization

    init(
        currentEnvironment: APIEnvironmentType,
        baseURL: URL? = nil
    ) {
        self.currentEnvironment = currentEnvironment
        _baseURL = baseURL
    }

    // MARK: - Public API

    public func baseURL(
        file: StaticString = #file,
        line: UInt = #line
    ) -> URL {
        guard let url = _baseURL else {
            fatalError(
                "There are no requests without a baseURL, it must be set!",
                file: file,
                line: line
            )
        }
        return url
    }
}
