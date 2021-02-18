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

public struct AnyURLRequest: URLRequestProtocol {
    public private(set) var baseURL: URL
    public private(set) var path: String?
    public private(set) var method: HTTPMethod
    public private(set) var bodyParameters: [String: Any]?
    public private(set) var headers: [String: String]?
    
    public init(
        baseURL: URL,
        path: String? = nil,
        method: HTTPMethod,
        bodyParameters: [String : Any]? = nil,
        headers: [String : String]? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
}
