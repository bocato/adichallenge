import Foundation

public struct EquatableErrorWrapper: Equatable {
    public let rawError: Error

    public init(_ rawError: Error) {
        self.rawError = rawError
    }

    public static func == (lhs: EquatableErrorWrapper, rhs: EquatableErrorWrapper) -> Bool {
        let lhsAsNSError = lhs.rawError as NSError
        let rhsAsNSError = rhs.rawError as NSError
        return lhsAsNSError == rhsAsNSError
    }
}
