import Foundation
import NetworkingInterface

protocol APIErrorMapperProtocol {
    func parse(_ error: Error) -> APIError
}

final class DefaultAPIErrorMapper: APIErrorMapperProtocol {
    func parse(_ rawError: Error) -> APIError {
        if let httpError = rawError as? HTTPRequestError, case let .apiError(apiError) = httpError {
            return apiError
        } else {
            return APIError(code: -1, title: "Error", message: "Unexpected API error.")
        }
    }
}
