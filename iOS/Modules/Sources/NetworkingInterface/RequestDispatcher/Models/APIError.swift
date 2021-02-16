import Foundation

public struct APIError: Error, CustomNSError, Equatable {
    // MARK: - CustomNSError

    public static var errorDomain: String { "APIError" }
    public var errorCode: Int { code }
    public var errorUserInfo: [String: Any] {
        [
            "code": code,
            "title": title,
            "message": message,
        ]
    }

    // MARK: - Properties

    public let code: Int
    public let title: String
    public let message: String

    // MARK: - Initialization

    public init(
        code: Int,
        title: String,
        message: String
    ) {
        self.code = code
        self.title = title
        self.message = message
    }

    // MARK: - Equatable

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.code == rhs.code &&
            lhs.title == rhs.title &&
            lhs.message == rhs.message
    }
}

public extension Error {
    func asNSError() -> NSError {
        self as NSError
    }
}

#if DEBUG
    public extension APIError {
        static func fixture(
            code: Int = -1,
            title: String = "APIError Title",
            message: String = "APIError Message"
        ) -> Self {
            .init(
                code: code,
                title: title,
                message: message
            )
        }
    }
#endif
