import Foundation

public typealias APIError = Error
public extension APIError {
    func asNSError() -> NSError {
        self as NSError
    }
}
