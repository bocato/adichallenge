import Foundation

/// This replaces the system's `fatalError` implementation, calling our util in order to make it
/// possible for us to capture it's parameters, results and such, then unit test our fatal errors 🎉
public func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

/// Defines a Wrapper to enable exchanging the system's implementation for ours.
public enum FatalErrorUtil {
    /// The closure that will call a system's `fatalError` implementation
    public static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure

    /// The reference to the `fatalError` implementation provided by Swift
    public static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }

    /// Static method to replace the `fatalError` implementation with a custom one.
    public static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
        fatalErrorClosure = closure
    }

    /// Restores the `fatalError` implementation with the default one.
    public static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}
