import Foundation

public enum HTTPRequestError: Error, Equatable {
    case requestDataSerialization(Error)
    case networking(Error)
    case invalidHTTPResponse
    case unexpectedAPIError
    case apiError(APIError)
    case unreachableNetwork

    public static func == (lhs: HTTPRequestError, rhs: HTTPRequestError) -> Bool {
        switch (lhs, rhs) {
        case let (.requestDataSerialization(e1), .requestDataSerialization(e2)):
            return (e1 as NSError) == (e2 as NSError)
        case let (.networking(e1), .networking(e2)):
            return (e1 as NSError) == (e2 as NSError)
        case (.invalidHTTPResponse, .invalidHTTPResponse):
            return true
        case (.unexpectedAPIError, .unexpectedAPIError):
            return true
        case let (.apiError(e1), .apiError(e2)):
            return e1 == e2
        case (.unreachableNetwork, .unreachableNetwork):
            return true
        default:
            return false
        }
    }
}
