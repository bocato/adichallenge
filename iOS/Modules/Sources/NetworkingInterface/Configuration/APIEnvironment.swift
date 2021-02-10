import Foundation

/// Provides an interface for the services enviroment properties
public protocol APIEnvironmentProvider {
    /// Defines the current enviroment
    var currentEnvironment: APIEnvironmentType { get set }
    /// Provides de base URL for the services
    var baseURL: URL { get }
}

// MARK: - Enums

/// Defines de current application environment
///
/// - dev: development servers
public enum APIEnvironmentType: String {
    case development
}
