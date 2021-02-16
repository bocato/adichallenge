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
            return .init(
                code: -1,
                title: L10n.Common.ApiError.title,
                message: L10n.Common.ApiError.message
            )
        }
    }
}
