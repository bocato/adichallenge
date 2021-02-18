import Foundation

/// Provides the base URL's for especific endpoints.
/// Should be implemented on the application container or some module that knows about the environment and requests.
public protocol BaseURLProviding {
    func baseURL<Endpoint>(
        for endpoint: Endpoint,
        environment: APIEnvironmentIdentifier
    ) -> URL?
}

#if DEBUG
public final class BaseURLProviderStub: BaseURLProviding {
    public init() {}
    public var urlToBeReturned: URL?
    public func baseURL<Endpoint>(
        for endpoint: Endpoint,
        environment: APIEnvironmentIdentifier
    ) -> URL? { urlToBeReturned }
}
#endif
