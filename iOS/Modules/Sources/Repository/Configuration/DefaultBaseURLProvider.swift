import Foundation
import NetworkingInterface

// Simplified implementation... This can be instatiated from a file, CI or else...
// And have more intricate logic to select the correct enviroments and such
public final class DefaultBaseURLProvider: BaseURLProviding {
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public API
    
    public func baseURL<Endpoint>(
        for endpoint: Endpoint,
        environment: APIEnvironmentIdentifier
    ) -> URL? {
        guard let path = endpoint as? String else { return nil }
        if path.contains("/product") {
            return URL(string: "http://localhost:3001")
        } else if path.contains("/reviews") {
            return URL(string: "http://localhost:3002")
        }
        return nil
    }
}
