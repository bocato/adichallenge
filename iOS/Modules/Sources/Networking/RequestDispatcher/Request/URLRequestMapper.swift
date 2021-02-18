import Foundation
import NetworkingInterface

extension URLRequestProtocol {
    func mapToURLRequest(using jsonSerializer: JSONSerialization.Type = JSONSerialization.self) throws -> URLRequest {
        var endpointURL = baseURL
        if let path = path, !path.isEmpty {
            endpointURL = endpointURL.appendingPathComponent(path)
        }
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        if let bodyParameters = bodyParameters {
            urlRequest.httpBody = try jsonSerializer.data(withJSONObject: bodyParameters, options: .fragmentsAllowed)
        }
        return urlRequest
    }
}
