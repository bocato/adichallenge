import Foundation

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

public protocol URLRequestProtocol {
    var baseURL: URL { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var bodyParameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension URLRequestProtocol {
    var bodyParameters: [String: Any]? { nil }
    var headers: [String: String]? { nil }
}
