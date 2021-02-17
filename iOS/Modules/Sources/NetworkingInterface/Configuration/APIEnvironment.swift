import Foundation

/// Provides the base URL's for especific endpoints
public protocol BaseURLProviding {
    func baseURL<Endpoint>(
        for endpoint: Endpoint,
        environment: APIEnvironmentIdentifier
    ) -> URL?
}

/// Provides an interface for the services enviroment properties
public protocol APIEnvironmentProvider {
    /// Defines the current enviroment
    var currentEnvironment: APIEnvironmentIdentifier { get set }
    
    /// Provides de base URL for the services
    func baseURL<Endpoint>(
        forEndpoint endpoint: Endpoint,
        file: StaticString,
        line: UInt
    ) -> URL
}

public extension APIEnvironmentProvider {
    /// Provides de base URL for the services
    func baseURL<Endpoint>(
        forEndpoint endpoint: Endpoint
    ) -> URL {
        baseURL(
            forEndpoint: endpoint,
            file: #file,
            line: #line
        )
    }
}

// MARK: - Enums

/// Defines de current application environment
///
/// - dev: development servers
public enum APIEnvironmentIdentifier: String {
    case development
}
