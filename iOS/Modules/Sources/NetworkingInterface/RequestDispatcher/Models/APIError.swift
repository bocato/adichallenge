import Foundation

public struct APIError: Error, CustomNSError, Equatable {
    // MARK: - CustomNSError
    public static var errorDomain: String { "APIError" }
    public var errorCode: Int { rawError.asNSError().code }
    public var errorUserInfo: [String : Any] { rawError.asNSError().userInfo }
    
    // MARK: - Properties
    
    public let rawError: Error
    
    // MARK: - Initialization
    
    public init(rawError: Error) {
        self.rawError = rawError
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.rawError.asNSError() == rhs.rawError.asNSError()
    }
}
public extension Error {
    func asNSError() -> NSError {
        self as NSError
    }
}
