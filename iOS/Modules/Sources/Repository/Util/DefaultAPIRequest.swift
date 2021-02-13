import Foundation
import NetworkingInterface

struct DefaultAPIRequest: URLRequestProtocol {
    let path: String?
    let method: HTTPMethod
    let bodyParameters: [String: Any]?
    let headers: [String: String]?

    private let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
    ]

    init(
        method: HTTPMethod,
        path: String? = nil,
        bodyParameters: [String: Any]? = nil,
        extraHeaders: [String: String] = [:]
    ) {
        self.method = method
        self.path = path
        self.bodyParameters = bodyParameters
        var headersToApply = defaultHeaders
        extraHeaders.forEach { headersToApply[$0.key] = $0.value }
        headers = headersToApply
    }
}
